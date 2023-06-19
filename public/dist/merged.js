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

};

let CellList = {};

core.CellHash = CellHash;
core.CellList = CellList;


class CellWrapper {
  uid = ''
  parent = false
  prev = false
  type = "input"
  element = document.body
  state = 'idle'

  focusNext(startpoint) {
    console.log('next');
    const pos = CellList[this.sign].indexOf(this.uid);
    if (pos + 1 < CellList[this.sign].length) {
      CellHash.get(CellList[this.sign][pos + 1]).display?.editor?.focus();
    } else {
      this.addCellAfter();
    }
  }

  focusPrev(startpoint) {
    console.log('prev');
    const pos = CellList[this.sign].indexOf(this.uid);
    if (pos - 1 > 0) {
      CellHash.get(CellList[this.sign][pos - 1]).display?.editor?.focus();
    }
  }  

  morph(template, input) {
    this.type = 'input';
    console.log('morph');

    const cell   = document.getElementById(`${this.uid}---output`);
    //make it different id, so it will not conflict
    cell.id = cell.id + '--old';
    const editor = cell.firstChild; 
  
    const parentcellwrapper = cell.parentNode.parentNode;
  
    parentcellwrapper.insertAdjacentHTML('afterend', template);
    this.element = document.getElementById(`${this.uid}---input`);

    this.element.appendChild(editor);
    cell.remove();

    this.toolbox();
  }


  updateState(state) {
    const loader = document.getElementById(this.uid+"---"+this.type).parentNode.getElementsByClassName('loader-line')[0];

    console.log(state);
      if (state === 'pending')
        loader.classList.add('loader-line-pending');
      else
        loader.classList.remove('loader-line-pending');
    
    this.state = state;
  }

  toolbox() {
    if (this.type === 'output') throw 'not possible. this is a child cell';
    
    const body = document.getElementById(this.uid).parentNode;
    const toolbox = body.getElementsByClassName('frontend-tools')[0];
    const hide    = body.getElementsByClassName('node-settings-hide')[0];
    const addafter   = body.getElementsByClassName('node-settings-add')[0];
    body.onmouseout  =  function(ev) {toolbox.classList.remove("tools-show");};
    body.onmouseover =  function(ev) {toolbox.classList.add("tools-show");}; 
    const addCellAfter = this.addCellAfter;
    const uid = this.uid;

    addafter.addEventListener("click", function (e) {
      addCellAfter(uid, self);
    });

    hide.addEventListener("click", function (e) {
      if(document.getElementById(uid).getElementsByClassName('output-cell').length === 0) {
        alert('The are no output cells can be hidden');
        return;
      }
      document.getElementById(uid+"---input").classList.toggle("cell-hidden");
      const svg = hide.getElementsByTagName('svg');
      svg[0].classList.toggle("icon-hidden");
      socket.send(`CellObj["${uid}"]["props"] = Join[CellObj["${uid}"]["props"], <|"hidden"->!CellObj["${uid}"]["props"]["hidden"]|>]`);
    });    
  }
  
  addCellAfter(uid) {  
    const id = uid || this.uid;
    var q = 'NotebookOperate["'+id+'", CellListAddNewAfter]';

    this?.display?.forceFocusNext();

    socket.send(q);  
  }
  
  constructor(template, input) {
    this.uid = input["id"];
    this.type = input["type"];
    this.state = input["state"];
    this.sign = input["sign"];

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
        document.getElementById(input["after"]["id"]+"---output").parentNode.parentNode.insertAdjacentHTML('afterend', template);
      }
      
      if (beforeType === 'input' && currentType === 'output') {
        console.log("output cell after inputcell");
        document.getElementById(input["after"]["id"]).insertAdjacentHTML('beforeend', template);
      }   
      
      if (beforeType === 'output' && currentType === 'output') {
        console.log("output cell after outputcell");
        document.getElementById(input["after"]["id"]+"---output").insertAdjacentHTML('afterend', template);
      }     
      
      CellList[this.sign].splice(pos+1, 0, input["id"]);


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
          document.getElementById(prev.uid+"---output").parentNode.insertAdjacentHTML('beforeend', template);
        }
        
      } else {
        document.getElementById(this.sign).insertAdjacentHTML('beforeend', template);
      }

      CellList[this.sign].push(this.uid);
    }

    CellHash.add(this);

    this.element = document.getElementById(this.uid+"---"+this.type);
    if (this.type === 'input') this.toolbox();

    this.display = new window.SupportedCells[input["display"]].view(this, input["data"]);    
    
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
      document.getElementById(`${this.uid}---${this.type}`)?.remove();
    }    
  }
  
  remove() {
    socket.send(`NotebookOperate["${this.uid}", CellListRemoveAccurate];`);
  }
  
  save(content) {
    //const fixed = content.replaceAll('\\\"', '\\\\\"').replaceAll('\"', '\\"');
    socket.send(`NotebookOperate["${this.uid}", CellObjSave, "${content}"];`);
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

    socket.send(q);    
  }
}

core.FrontEndRemoveCell = async function (args, env) {
  var input = await interpretate(args[0]);
  CellHash.get(input["id"]).dispose();
};

core.FrontEndCellMorphInput = async function (args, env) {
  var template = interpretate(args[0]);
  var input = await interpretate(args[1]);

  CellHash.get(input["id"]).morph(template, input);
}; 

core.FrontEndCellError = async function (args, env) {
  alert(await interpretate(args[1], env));
};

core.FrontEndTruncated = async function (args, env) {
  env.element.innerHTML = (await interpretate(args[0], env) + " ...");
};

core.IconizeWrapper = function (args, env) {
  env.element.innerText = "{ ... }";
};

core.IconizeWrapper.destroy = (args, env) => {};

core.FrontEndTruncated.destroy = (args, env) => {};

core.FrontEndJSEval = function (args, env) {
  eval(interpretate(args[0]));
}; 

core.FrontEndGlobalAbort = function (args, env) {
  const arr = Object.keys(CellHashStorage);
  arr.forEach((el)=>{
    CellHash.get(el).updateState('idle');
  });
};

core.FrontEndUpdateCellState = async function (args, env) {
  const input = await interpretate(args[0], env);
  console.log('update state');
  console.log(input["id"]);

  CellHash.get(input["id"]).updateState(input["state"]);
};

core.FrontEndCreateCell = async function (args, env) {
  var template = interpretate(args[0]);
  var input = await interpretate(args[1]);

  new CellWrapper(template, input);
};

core.FrontEndCreatePreviewCell = function (args, env) {
  //console.log(window.atob(args));
  core.PreviewCell(env.element, window.atob(args));
};







const bundleloaded = new Event("bundleloaded");
window.dispatchEvent(bundleloaded);
