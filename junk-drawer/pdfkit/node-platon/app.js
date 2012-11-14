
var PDFDocument = require('pdfkit');

var doc = new PDFDocument;

doc.font('Courier').fontSize(12);
doc.margins = {
  top: 72,
  right: 72,
  bottom: 72,
  left: 108
};

function print_anything(thing) {
    doc.text(thing, 0, doc.cursor, {
        width: 310
    })
}

function print_character(name) {
  doc.text(name, 266, doc.cursor, {
    width: 310
  });
}

function print_dialog(line) {
  doc.text(line, 194.4, doc.cursor, {
    width: 208.8
  });
  doc.moveDown(1);
}

function print_action(line) {
  doc.text(line, 122.4, doc.cursor, {
    width: 374.4
  });
  doc.moveDown(1);
}

function print_paren(paren) {
  doc.text(paren, 244.8, doc.cursor, {
    width: 108
  });
}

function print_transition(trans) {
  doc.text(trans, 432, doc.cursor, {
    width: 144
  });
  doc.moveDown(1);
}

var stringName = "Maxwell";
var stringDialog = "Lorem ipsum <u>dolor</u> sit amet, consectetur <i>adipisicing</i> elit, sed <b>do</b>.";
var stringAction = "Sed ut perspiciatis unde omnis iste natus.";
var stringParen = "(lovingly)";
var stringTransition = "FADE IN:";

doc.image('smash.png', 100, 100);
doc.add_page;

print_anything("Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")

// print_transition(stringTransition)
// print_action(stringAction)
// print_character(stringName)
// print_dialog(stringDialog)
// print_character(stringName)
// print_dialog(stringDialog)
// print_character(stringName)
// print_paren(stringParen)
// print_dialog(stringDialog)

doc.write('out.pdf');


