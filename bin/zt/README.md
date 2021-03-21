# ZeroTier Shell Script

*Disclaimer: I am in no way connected to the ZeroTier service. This script is simply meant to ease the connection to networks when there are several computers awaiting connections to ZeroTier networks.*

## About

The purpose of this script is to ease the installation of ZeroTier, allowing the user to choose from pre-determined networks, or manually inputting one. The script handles everything on its own, and even has multi-language support.

## Usage

### **Syntax**

`./zt.sh <arg1>`

### \<arg1> options

* ### Display the help text

Use `help` to display the help text.

* ### Language selection

Input a two-letter language code to overwrite the language outputted by the script.

*Currently supported languages:*

* *English - `en`*
* *Norwegian - `no`/`nb`/`nn`*

## **Contribution**

### **Translation**

Translation files go in the `langs` folder, and the file name should start with the relevant two-letter language code, and ending in `.sh`. The string variable name itself must not be translated. Please use one of the existing lanugage files as a template.

## **Customization**

If you need to predefine your own networks, you can append them to the `zt.sh` file below the `networkid_1` line. Remember to add the relevant checks in the script if you do.

## **TO DO**

* Allow the users to name the manually inputted networks, and save them for future use.
* Make customizations easier, allowing users to easily predefine their own networks without changing any code.
