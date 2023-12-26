  function __emptyFalse(a) {
    if (a === '') return false;
    return a;
  }
  
  //CELL TYPES / LANGUAGES
  window.SupportedCells = {};
  window.SupportedLanguages = [];
  //GLobals
  window.Extensions = [];
  
  window.CellHashStorage = {};
  
  const CellHash = {
    add: (obj) => {
      CellHashStorage[obj.uid] = obj;
    },
  
    get: (uid) => {
      return CellHashStorage[uid];
    },
  
    remove: (uid) => {
      CellHashStorage[uid] = undefined;
    },
  
  }
  
  let CellList = {};
  
  core.CellHash = CellHash;
  core.CellList = CellList;

  let currentCell;
  
  let forceFocusNew = false;
  let focusDirection = 1;


  class CellWrapper {
    uid = ''
    parent = false
    prev = false
    type = "input"
    element = document.body
    state = 'idle'

    epilog = []
    prolog = []
    
    constructor(template, input, list, eventid) {
      this.uid = input["Hash"];
      this. 


      <|After -> Null, Before -> Null, Data -> 1+1, Display -> codemirror, Hash -> 238babc5-3ba1-4c38-ad76-60daafd805cb, Props -> <||>, State -> Evaluation, Type -> Input, UID -> Null, Notebook -> 1c6a84a3-fdea-4743-82cc-bdfb804c7656|>




      
      this.uid = input["id"];
      this.type = input["type"];
      this.state = input["state"];
      this.sign = input["sign"];
      this.props = input["props"];
  
      if (!(this.sign in CellList)) CellList[this.sign] = [];

  
      if ('after' in input) {
        console.log('inserting after something');
  
        const beforeType = input["after"]["type"];
        const currentType = input["type"];
        const pos = CellList[this.sign].indexOf(input["after"]["id"]);
  
        if (beforeType === 'input' && currentType === 'input') {
          console.log("input cell after inputcell");
          document.getElementById(input["after"]["id"]).parentNode.insertAdjacentHTML('afterend', template);
        }
  
        if (beforeType === 'output' && currentType === 'input') {
          console.log("input cell after outputcell");
          document.getElementById(input["after"]["id"]+"---output").parentNode.parentNode.parentNode.insertAdjacentHTML('afterend', template);
        }
        
        if (beforeType === 'input' && currentType === 'output') {
          console.log("output cell after inputcell");
          document.getElementById(input["after"]["id"]).insertAdjacentHTML('beforeend', template);
        }   
        
        if (beforeType === 'output' && currentType === 'output') {
          console.log("output cell after outputcell");
          document.getElementById(input["after"]["id"]+"---output").parentNode.insertAdjacentHTML('afterend', template);
        }     
        
        CellList[this.sign].splice(pos+1, 0, input["id"]);
  
  
      } else if ('before' in input) {

        
  
        const beforeType = input["before"]["type"];
        const currentType = input["type"];
        const pos = CellList[this.sign].indexOf(input["before"]["id"]);

        console.log('inserting '+input["id"]+'---'+input["type"]+' before cell '+input["before"]["id"]+'---'+beforeType);
  
        if (beforeType === 'input') {
          console.log("input cell before inputcell");
          document.getElementById(input["before"]["id"]).parentNode.insertAdjacentHTML('beforebegin', template);
        }
  
        if (beforeType === 'output') {
          console.log("input cell before outputcell");
          document.getElementById(input["before"]["id"]+"---output").parentNode.parentNode.parentNode.insertAdjacentHTML('beforebegin', template);
        }   
        
        CellList[this.sign].splice(pos, 0, input["id"]);

      } else {
        
        console.log('plain insertion');
        //inject into the right place
        if (this.type === 'output') {
          const prev = CellHash.get(CellList[this.sign].slice(-1));
          if (prev.type === 'input') {
            //inject into parent's holder
            document.getElementById(prev.uid).insertAdjacentHTML('beforeend', template);
          } else {
            //find the parent's holder and inject into the end
            document.getElementById(prev.uid+"---output").parentNode.parentNode.insertAdjacentHTML('beforeend', template);
          }
          
        } else {
          document.getElementById(this.sign).insertAdjacentHTML('beforeend', template);
        }
  
        CellList[this.sign].push(this.uid);
      }
  
      CellHash.add(this);
  
      this.element = document.getElementById(this.uid+"---"+this.type);
      this.element.cell = this;

      if (this.type === 'input') this.toolbox();
      
      this.horisontalToolbox();
  
      this.display = new window.SupportedCells[input["display"]].view(this, input["data"]);  
      
      const self = this;

      if (this.type == 'input') {
        this.element.addEventListener('focusin', ()=>{
          server.socket.send(`NotebookSelectCell["${self.uid}"]`);
          currentCell = self;
          //console.warn('Focus!');
          //console.warn(self.element);
        });
      } else  {
        //console.warn('this is output!');
        //console.warn(this.type);
      }

      
      const newCellEvent = new CustomEvent("newCellCreated", { detail: self });
      window.dispatchEvent(newCellEvent);

      //console.log('New cell');
      //console.log(this.type);
      //force focus flag
      if (forceFocusNew && this.type == 'input') {
        console.warn('focus input cell');
        forceFocusNew = false;
        this.display?.editor?.focus();
      }
      
      return this;
    }
    
    dispose() {
      //remove a single cell
  
      //call dispose action
      this.display.dispose();
  
      //remove from the list
      const pos = CellList[this.sign].indexOf(this.uid);
      CellList[this.sign].splice(pos, 1);
      //remove hash
      CellHash.remove(this.uid);
  
      //remove dom holders
      if (this.type === 'input') {
        document.getElementById(this.uid).parentNode.remove();
      } else {
        document.getElementById(`${this.uid}---${this.type}`)?.parentNode.remove();
      }    
    }
    
    remove(jump = false, direction = 1) {
      server.socket.send(`NotebookOperate["${this.uid}", CellListRemoveAccurate];`);
      if (jump) {
        let pos = CellList[this.sign].indexOf(this.uid);
        let current = this;
        const origin = this;

        if (direction > 0) {

          while (pos + 1 < CellList[this.sign].length) {
            current = CellHash.get(CellList[this.sign][pos + 1]);
            pos++;

            if (origin.type == 'output') {
              current.focus();
              break;
            }

            if (origin.type == 'input' && current.type == 'input') {
              current.focus();
            }
          } 

        } else {

          if (pos - 1 >= 0) {
            current = CellHash.get(CellList[this.sign][pos - 1]);
            current.focus();
          } 

        }
        
      }
    }
    
    save(content) {
      //const fixed = content.replaceAll('\\\"', '\\\\\"').replaceAll('\"', '\\"');
      server.socket.send(`NotebookOperate["${this.uid}", CellObjSave, "${content}"];`);
    }

    evalString(string) {
      const signature = this.sign;
      return server.askKernel(`Module[{result}, WolframEvaluator["${string}", False, "${signature}", Null][(result = #1)&]; result]`);
    }
    
    eval(content) {
      if (this.state === 'pending') {
        alert("This cell is still under evaluation");
        return;
      }
  
      //const fixed = content.replaceAll('\\\"', '\\\\\"').replaceAll('\"', '\\"');
      const q = `NotebookEvaluate["${this.uid}"]`;
  
      if($KernelStatus !== 'good' && $KernelStatus !== 'working') {
        alert("No active kernel is attached");
        return;
      }
  
      server.socket.send(q);    
    }
  }