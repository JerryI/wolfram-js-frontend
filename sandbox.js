    var $objetsstorage = {};

    core.FrontEndRemoveCell = function(args, env) {
      var input = JSON.parse(interpretate(args[0]));
      if(input["parent"] === "") {
        document.getElementById(input["id"]).remove();
      } else {
        document.getElementById(input["id"]+"---"+input["type"]).remove();
      }
    }

    core.FrontEndMoveCell = function(args, env) {
      var input = JSON.parse(interpretate(args[0]));

      //document.getElementById(input["cell"]["id"]+"---"+input["cell"]["type"]).remove();

      const cell = document.getElementById(input["cell"]["id"]+"---output");

      const parent = document.getElementById(input["parent"]["id"]);

      console.log(parent);
      console.log(cell);

      cell.id = input["cell"]["id"]+"---"+input["cell"]["type"];

      const newDiv = document.createElement("div");
      newDiv.id = input["cell"]["id"];
      newDiv.classList.add("parent-node");      

      parent.insertAdjacentElement('afterend', newDiv);

      newDiv.appendChild(cell);

      //buggy thing

    }

    core.FrontEndMorphCell = function(args, env) {
      var input = JSON.parse(interpretate(args[0]));
      console.log(input);

      //not implemented
    }

    core.FrontEndClearStorage = function(args, env) {
      var input = JSON.parse(interpretate(args[0]));
      console.log(input);

      input["storage"].forEach(element => {
        delete $objetsstorage[element];
      });
      
      //not implemented
    }

    core.FrontEndCreateCell = function(args, env) {
      var input = JSON.parse(interpretate(args[0]));
      console.log(input);
  
      $objetsstorage = Object.assign({}, $objetsstorage, input["storage"]);
    
      var target;
  
      if (input["parent"] === "") {
        // create a new div element
        const newDiv = document.createElement("div");
        newDiv.id = input["id"];
        newDiv.classList.add("parent-node");
  
        if(input["prev"] != "") {
  
          //console.log(input["prev"]);
          console.log(input["prev"]);
          const p = document.getElementById(input["prev"]);
          console.log(p);
          p.insertAdjacentElement('afterend', newDiv);
  
        } else {
  
          document.getElementById(input["sign"]).appendChild(newDiv);
  
        }
  
        target = newDiv;
        last = input["id"];
      } else {
        target = document.getElementById(input["parent"]);
      }
  
      var notebook = input["sign"];
      var uuid = input["id"];
  
      //var newCell = CodeMirror(target, {value: input["data"], mode:  "mathematica", extraKeys: {
      //  "Shift-Enter": function(instance) { 
      //     eval(instance.getValue(), notebook, uuid);
      //  },
      // }});
  
      //newCell.on("blur",function(cm,change){ socket.send('CellObj["'+cm.display.wrapper.id.split('---')[0]+'"]["data"] = "'+cm.getValue().replaceAll('\"','\\"')+'";'); });
  
      var wrapper = document.createElement("div");
      target.appendChild(wrapper);
  
      wrapper.id = input["id"]+"---"+input["type"];
  
      wrapper.classList.add(input["type"] + '-node');
  
      /*const editor = new EditorView({
        doc: input["data"],
        extensions: [placeholders, minimalSetup,
        
          keymap({
            "Shift-Enter": (state, dispatch) => {
              eval(state.doc.toString(), notebook, uuid);
            }
          })
        ],
        parent: wrapper
      });*/

      var uid = input["id"];
  
      const editor =  new EditorView({
          doc: input["data"],
          extensions: [
              highlightActiveLineGutter(),
              highlightSpecialChars(),
              history(),
              drawSelection(),
              dropCursor(),
              EditorState.allowMultipleSelections.of(true),
              indentOnInput(),
              syntaxHighlighting(defaultHighlightStyle, { fallback: true }),
              bracketMatching(),
              closeBrackets(),
              autocompletion(),
              rectangularSelection(),
              crosshairCursor(),
              highlightActiveLine(),
              highlightSelectionMatches(),
              StreamLanguage.define(mathematica),
              placeholders,
              keymap.of([
                  { key: "Shift-Enter", preventDefault: true, run: function (editor, key) { console.log(editor.state.doc.toString()); eval(editor.state.doc.toString(), notebook, uuid); } }, ...defaultKeymap, ...historyKeymap
              ]),
              EditorView.updateListener.of((v) => {
                  if (v.docChanged) {
                      console.log(v.state.doc.toString());
                      socket.send('CellObj["'+uid+'"]["data"] = "'+v.state.doc.toString().replaceAll('\"','\\"')+'";');
                  }
              })
          ],
          parent: wrapper
      });      
  
  
  
    }
