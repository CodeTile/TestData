# TestData
A collection of TSQL scripts and data for data-scrubbing or for generating test data.

## Based upon (and credits)
Random Word Generation for Data Scrubbing  
https://www.sqlservercentral.com/articles/random-word-generation-for-data-scrubbing

## Examples  
At the bottom of each SQL script there is an example of how to call random data.  

### Words
	1. ```SELECT dbo.ds_fnRandomWord() ```  for a single random word.
	2. ```SELECT dbo.ds_fnRandomWords(10)``` for a sentence of up to 1000 characters, the number in the brackets is the number of words to generate.
### First Names
	1. ```SELECT dbo.ds_fnRandomFirstName() ```  for a single random word.
	2. ```SELECT dbo.ds_fnRandomFirstNames(10)``` for a sentence of up to 1000 characters, the number in the brackets is the number of names to generate.

### Last Names
	1. ```SELECT dbo.ds_fnRandomLastName() ```  for a single random word.
	2. ```SELECT dbo.ds_fnRandomLastNames(10)``` for a sentence of up to 1000 characters, the number in the brackets is the number of names to generate.

### Phone numbers
	1. ```SELECT dbo.ds_fnRandomPhoneNumber() ```  for a single random word.
	2. ```SELECT dbo.ds_fnRandomPhoneNumbers(10)``` for a sentence of up to 1000 characters, the number in the brackets is the number of phone numbers to generate.






## Sources
##### Uk Phone numbers
https://www.ofcom.org.uk/phones-telecoms-and-internet/information-for-industry/numbering/numbers-for-drama

##### British Surnames
https://britishsurnames.co.uk/surnames

##### Words
https://github.com/powerlanguage/word-lists  
https://www.thefreedictionary.com/5-letter-words.htm

