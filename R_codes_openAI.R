library(httr)
library(jsonlite)
library(dotenv)

# Load environment variables
curr_path = "C:/Users/kevin/OneDrive - Cornell University/training/Machine Learning/Training/PharmaSUG/2025/.env"
dotenv::load_dot_env(file=curr_path)

# Set your OpenAI API key from .env file
# api_key <- "xxxx"
api_key <- Sys.getenv("OPENAI_API_KEY_R")

# Define the request URL
api_url <- "https://api.openai.com/v1/chat/completions"

prompt <- "Tell me about CDISC in 200 words"

# Define the request body
body <- list(
  model = "gpt-3.5-turbo",
  messages = list(
    list(role = "system", content = "You are a helpful assistant."),
    list(role = "user", content = prompt )
  )
)

# Make the API request
response <- POST(
  api_url,
  add_headers('Authorization' = paste("Bearer", api_key),
              'Content-Type' = "application/json"),
  body = jsonlite::toJSON(body, auto_unbox = TRUE),
  encode = "json"
)

# Parse the response (Json to R List)
result <- content(response, as = "parsed")

# Print the response
print(result$choices[[1]]$message$content)
