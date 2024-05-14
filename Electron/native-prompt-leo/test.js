const prompt = require(".");

prompt("Test Title", "Test Text", {
  defaultText: "Default test",
  okButtonLabel: "Submit",
  cancelButtonLabel: "Abort"
}).then(res => {
  console.log(res);
})