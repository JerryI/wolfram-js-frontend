function __emptyFalse(a) {
  if (a === '') return false;
  return a;
}

var SupportedCellDisplays = {};
var CellHash = {};

core.CellHash = CellHash;

class CellWrapper {
  uid = ''
  parent = false
  prev = false
  type = "input"
  element = document.body
  state = 'idle'

  findFirstParent() {
    let cell = this;
    while(true) {
      if (!cell.parent) cell = CellHash[cell.prev]; else cell = CellHash[cell.parent];
      if (!(cell instanceof CellWrapper)) cell = this;
      if (!cell.prev) break;
    }
    return cell;
  }

  findLast() {
    let cell = this;
    while(true) {
      cell = CellHash[cell.next];
      if (!(cell instanceof CellWrapper)) cell = this;
      if (!cell.next) break;
    }
    return cell;
  }  

  findNext() {
    return CellHash[this.next]; 
  }

  focusNext(startpoint) {
    console.log('next');
    console.log(this);    
    if (startpoint.uid !== this.uid) return this.display?.editor?.focus();
 

    if (this.child)
      return CellHash[this.child].focusNext(startpoint)
    
    if (this.next)
      return CellHash[this.next].focusNext(startpoint)
    
    if (this.parent)
      if (CellHash[this.parent].next)
        return CellHash[CellHash[this.parent].next].focusNext(startpoint)
    
    if (this.parent) CellHash[this.parent].addCellAfter(); else this.addCellAfter();
  }

  focusPrev(startpoint) {
    console.log('prev');
    console.log(this);
    if (startpoint.uid !== this.uid) return this.display?.editor?.focus();

    if (this.prev)
      if (CellHash[this.prev].child)
        return CellHash[CellHash[this.prev].child].findLast().focusPrev(startpoint) 
    
    if (this.prev)
      return CellHash[this.prev].focusPrev(startpoint)
    
    if (this.parent)
      return CellHash[this.parent].focusPrev(startpoint)
  }  

  morph(template, input) {
    this.type = input["type"];

    const cell   = document.getElementById(`${this.uid}---output`);
    //make it different id, so it will not conflict
    cell.id = cell.id + '--old';
    const editor = cell.firstChild; 
  
    const parentcellwrapper = cell.parentNode.parentNode;
  
    parentcellwrapper.insertAdjacentHTML('afterend', template);
    this.element = document.getElementById(`${this.uid}---input`);

    this.element.appendChild(editor);
    cell.remove();

    if (this.next) {
      if (CellHash[this.parent].next) {
        CellHash[CellHash[this.parent].next].prev = this.uid;
      } else {
        this.next = false;
      }   
    }
    //FIXME when goes from up to down - error!!
    

    this.parent = false;
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
    if (this.parent) throw 'not possible. this is a child cell';
    
    const body = document.getElementById(this.uid).parentNode;
    const toolbox = body.getElementsByClassName('frontend-tools')[0];
    const hide    = body.getElementsByClassName('node-settings-hide')[0];
    const addafter   = body.getElementsByClassName('node-settings-add')[0];
    body.onmouseout  =  function(ev) {toolbox.classList.remove("tools-show")};
    body.onmouseover =  function(ev) {toolbox.classList.add("tools-show")}; 
    const addCellAfter = this.addCellAfter;
    const uid = this.uid;

    addafter.addEventListener("click", function (e) {
      addCellAfter(uid);
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
    var q = 'NotebookOperate["'+id+'", CellObjCreateAfter]';
    forceFocusNext = true;
    socket.send(q);  
  }
  
  constructor(template, input) {
    this.uid = input["id"];
    this.parent = __emptyFalse(input["parent"]);
    this.prev = __emptyFalse(input["prev"]);
    this.next = __emptyFalse(input["next"]);
    this.child = __emptyFalse(input["child"]);
    this.type = input["type"];
    this.state = input["state"];
    
    
    if (this.parent) {
      document.getElementById(this.parent).insertAdjacentHTML('beforeend', template);
    } else {
      if (this.prev)
        document.getElementById(this.prev).parentNode.insertAdjacentHTML('afterend', template);
      else
        document.getElementById("frontend-contenteditable").insertAdjacentHTML('beforeend', template);
    }
 
    this.element = document.getElementById(this.uid+"---"+this.type);
    if (!this.parent) this.toolbox();
    
    this.display = new SupportedCellDisplays[input["display"]](this, input["data"]);
    
    CellHash[this.uid] = this;
    
    return this;
  }
  
  dispose() {
    if (this.type === 'input') {
      document.getElementById(this.uid).parentNode.remove();
      CellHash[this.child]?.dispose();
    } else {
      document.getElementById(`${this.uid}---${this.type}`)?.remove();
      CellHash[this.next]?.dispose();
    }

    this.display.dispose();
    delete CellHash[this.uid];
  }
  
  remove() {
    socket.send(`NotebookOperate["${this.uid}", CellObjRemoveAccurate];`);
  }
  
  save(content) {
    socket.send(`CellObj["${this.uid}"]["data"] = "${content}";`);
  }
  
  eval(content) {
    if (this.state === 'pending') {
      alert("This cell is still under evaluation");
      return;
    }

    const fixed = content.replaceAll('\\\"', '\\\\\"').replaceAll('\"', '\\"');
    const q = `CellObj["${this.uid}"]["data"]="${fixed}"; NotebookEvaluate["${this.uid}"]`;

    if($KernelStatus !== 'good' && $KernelStatus !== 'working') {
      alert("No active kernel is attached");
      return;
    }

    socket.send(q);    
  }
}

core.FrontEndRemoveCell = function (args, env) {
  var input = interpretate(args[0]);
  CellHash[input["id"]].dispose();
};

core.FrontEndMorpCell = function (args, env) {
  var template = interpretate(args[0]);
  var input = interpretate(args[1]);

  CellHash[input["cell"]["id"]].morph(template, input["cell"]);
}; 

core.FrontEndCellError = function (args, env) {
  alert(interpretate(args[1]));
};

core.FrontEndTruncated = function (args, env) {
  env.element.innerHTML = interpretate(args[0]) + " ...";
}

core.IconizeWrapper = function (args, env) {
  env.element.innerText = "{ }";
}

core.IconizeWrapper.destroy = (args, env) => {}

core.FrontEndTruncated.destroy = (args, env) => {}

core.FrontEndJSEval = function (args, env) {
  eval(interpretate(args[0]));
} 

core.FrontEndGlobalAbort = function (args, env) {
  const arr = Object.keys(CellHash)
  arr.forEach((el)=>{
    CellHash[el].updateState('idle');
  });
}

core.FrontEndUpdateCellState = function (args, env) {
  const input = interpretate(args[0], env);

  CellHash[input["id"]].updateState(input["state"]);
}

core.FrontEndCreateCell = function (args, env) {
  var template = interpretate(args[0]);
  var input = interpretate(args[1]);

  new CellWrapper(template, input);
}






