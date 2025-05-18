/* Step 1: Read API Key */
filename apifile "E:\SASData\klee\GenAI\api_key.txt";

data _null_;
    infile apifile truncover;
    input line $200.;
    
    if index(line, '=') > 0 then do;
        /* Remove spaces */
        *line = compress(line, ' ', 'k');
        
        /* Separate key and value */
        key = scan(line, 1, '=');
        val = scan(line, 2, '=');

        /* Remove surrounding quotes if they exist */
        *val = strip(tranwrd(tranwrd(val, '"', ''), "'", ''));

        /* Assign to macro variable */
        call symputx(key, val);
    end;
run;

*%let openai_api_key = xxxxxxx ;

*%put &my_secret_key;
*%put &gemini_api;
*%put &chatgpt_api;
*%put &OPENAI_API_KEY;
*%put &OPENAI_API_KEY_R;
*%put &openai_api_key;

/* Step 2: Set Up Prompt and respose files */
filename prompt2 temp;  ** temporary prompt files;
filename resp "E:\SASData\klee\GenAI\resp.json"; ** response file in the local drive;

** Create temporary prompt files;
data _null_;
  file prompt2;
  put '{ "model": "gpt-3.5-turbo",';
  put '  "messages": [';
  put '    { "role": "user",';
  put '      "content": "Tell me about SAS in 200 words."';
  put '    }';
  put '  ]';
  put '}';
run;

/* Step 3: Send prompt to OpenAI */
proc http 
 method = "POST" 
 url	= "https://api.openai.com/v1/chat/completions"
 ct		= "application/json" 
 in		= prompt2 
 out	= resp;

 headers "Authorization" = "Bearer &openai_api_key.";
run; 
quit;

/* Step 4: Read response json files in the local drive */
libname response JSON fileref=resp;
data r_sas;
	set response.choices_message;
run;

proc print data=r_sas; run;
