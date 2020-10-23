
/**
 * @author MURA
 * @copyright insyma AG
 * @projectDescription insyma JavaScript Library Konfiguration FormValidation Module
 * @version 1.0 
 * 
 */
// Alle Validierungstexte
/*
insymaFormValidation.config.validationTexts = [
    "Bitte füllen Sie das Feld [label] aus!",			// für normale Validierung
    "Treffen Sie Ihre Wahl!",			// für Radiobuttons
    "Bitte korrekte E-Mail angeben!",			// für E-Mail-Feld
    "Nur Zahlen eingeben!",	        // für Dezimalzahlen
    "Bitte Nummer eingeben!",			// für Telefonnummer
    "Bitte geben Sie eine korrekte Währung an!",		// für Währung
    "Nur Zahlen sind erlaubt.",	        // für positive Ganzzahlen
    "Nur Zahlen sind erlaubt."			// für positive und negative Ganzzahlen
];
*/

// Querystring, der in der URL vom Redirect steht
insymaFormValidation.config.ThanksUrlVar = "thanks";
// Id des Containers mit dem Dankestext
insymaFormValidation.config.ThanksContainerId = "thanks";


var validationMessagesEng = {
	Header: "Header",
	Captcha: "required",
	Email: "(email)",
	Digits: "(Dig: 0-9)",
	Integers: "(Int: +- 0-9)",
	Decimal: "(Dec: 0.00)",
	Phone: "phone(+41 41 000 00 00)",
	Currency: "Cur(0.00)",
	NotEmpty: "(not empty)",
	Date: "(Date: dd.MM.yyyy)"
};

var validationMessagesFra = {
	Header: "Header",
	Captcha: "required",
	Email: "(email)",
	Digits: "(Dig: 0-9)",
	Integers: "(Int: +- 0-9)",
	Decimal: "(Dec: 0.00)",
	Phone: "phone(+41 41 000 00 00)",
	Currency: "Cur(0.00)",
	NotEmpty: "(not empty)",
	Date: "(Date: dd.MM.yyyy)"
};

var validationMessagesIta = {
	Header: "Header",
	Captcha: "required",
	Email: "(email)",
	Digits: "(Dig: 0-9)",
	Integers: "(Int: +- 0-9)",
	Decimal: "(Dec: 0.00)",
	Phone: "phone(+41 41 000 00 00)",
	Currency: "Cur(0.00)",
	NotEmpty: "(not empty)",
	Date: "(Date: dd.MM.yyyy)"
};

var validationMessagesDeu = {
	Header: "Folgende Felder sind zwingend und oder richtig abzufuellen:;",
	Captcha: "Code ungueltig",
	Email: "(nicht gueltig)",
	Digits: "(Zahl: 0-9)",
	Integers: "(Zahl: +- 0-9)",
	Decimal: "(Zahl: 0.00)",
	Phone: "(+41 41 000 00 00)",
	Currency: "(0.00)",
	NotEmpty: "(Kontrolleingabe fehlerhaft)",
	Date: "(Datum: dd.MM.yyyy)"
};

var validationLanguages = [validationMessagesDeu, validationMessagesFra, validationMessagesIta, validationMessagesEng];