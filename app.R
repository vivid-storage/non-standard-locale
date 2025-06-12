library(shiny)
library(bslib)

ui <- page_fluid(
  theme = bs_theme(bootswatch = "cerulean"),
  
  h1("Locale and Encoding Test App"),
  
  card(
    card_header("Current System Locale"),
    card_body(
      verbatimTextOutput("locale_info")
    )
  ),
  
  card(
    card_header("Locale-Dependent Behavior Tests"),
    card_body(
      h4("Date Formatting (varies by locale)"),
      verbatimTextOutput("date_format"),
      
      h4("Number Formatting (varies by locale)"),
      div(id = "number-format-section",
        verbatimTextOutput("number_format")
      ),
      
      h4("String Sorting/Collation (varies by locale)"),
      div(id = "string-sort-section",
        # Breaking the output into multiple, more targeted outputs
        h5(id = "string-sort-heading", "Japanese and Special Characters"),
        verbatimTextOutput("string_sort_japanese"),
        
        h5(id = "case-sort-heading", "Case Sensitivity Test"),
        verbatimTextOutput("string_sort_case")
      )
    )
  ),
  
  card(
    card_header("Japanese Text Display Test"),
    card_body(
      p("The following text should display properly if encoding is set correctly:"),
      h3("日本語のテキスト (Japanese Text)"),
      p(id = "japanese-hello", "こんにちは、世界! (Hello, World!)"),
      p(id = "japanese-test", "これは文字エンコーディングのテストです。 (This is a text encoding test.)")
    )
  ),
  
  card(
    card_header("Character Encoding Test"),
    card_body(
      p("Special characters from various languages:"),
      p(id = "german-text", "German: äöüß"),
      p(id = "french-text", "French: éèêëçàâ"),
      p(id = "russian-text", "Russian: Привет мир"),
      p(id = "greek-text", "Greek: Γειά σου Κόσμε"),
      p(id = "arabic-text", "Arabic: مرحبا بالعالم"),
      p(id = "thai-text", "Thai: สวัสดีชาวโลก"),
      p(id = "chinese-text", "Chinese: 你好，世界")
    )
  )
)

server <- function(input, output, session) {
  output$locale_info <- renderPrint({
    cat("Locale settings:\n")
    cat("----------------\n")
    print(Sys.getlocale())
    
    cat("\n\nEncoding information:\n")
    cat("--------------------\n")
    cat("Default encoding: ", getOption("encoding"), "\n")
    cat("Native encoding: ", localeToCharset(), "\n")
  })
  
  output$date_format <- renderPrint({
    # Date formatting varies by locale
    cat("Current date in system format: ", format(Sys.Date()), "\n")
    cat("Current date-time: ", format(Sys.time()), "\n\n")
    
    # Try Japanese-specific date formatting if locale is set correctly
    cat("Attempting Japanese date format (should show year/month/day in Japanese if locale is applied):\n")
    date_str <- format(Sys.Date(), "%Y年%m月%d日")
    cat(date_str, "\n")
  })
  
  output$number_format <- renderPrint({
    # Using distinct labels for better playwright targeting
    cat("NUMBER_FORMAT_TEST_START\n")
    cat("Decimal and thousand separators can vary by locale\n")
    x <- 1234567.89
    cat("Original number: ", x, "\n")
    cat("Formatted with prettyNum: ", prettyNum(x, big.mark=","), "\n")
    
    # Specific test for Japanese formatting if available
    cat("\nFormatting large numbers with format():\n")
    cat(format(1234567.89, scientific=FALSE), "\n")
    cat("NUMBER_FORMAT_TEST_END\n")
  })
  
  # Split the string sorting output into two separate outputs
  output$string_sort_japanese <- renderPrint({
    # Create some text with special characters to sort
    words <- c("あ", "い", "う", "え", "お", "か", "き", "く", "け", "こ", 
               "A", "B", "C", "Ä", "Z", "é", "ß")
    
    cat("Japanese Kana and Special Characters Sorting Test\n")
    cat("==============================================\n\n")
    
    cat("Original Japanese and special characters list:\n")
    for (i in seq_along(words)) {
      cat(sprintf("Item %d: %s\n", i, words[i]))
    }
    
    cat("\nSorted Japanese and special characters list:\n")
    sorted_words <- sort(words)
    for (i in seq_along(sorted_words)) {
      cat(sprintf("Sorted item %d: %s\n", i, sorted_words[i]))
    }
  })
  
  output$string_sort_case <- renderPrint({
    cat("Case Sensitivity Sorting Test\n")
    cat("===========================\n\n")
    
    # Test if case sensitivity in sorting is affected by locale
    mixed_case <- c("a", "A", "b", "B", "c", "C", "z", "Z")
    
    cat("Original mixed case list:\n")
    for (i in seq_along(mixed_case)) {
      cat(sprintf("Case item %d: %s\n", i, mixed_case[i]))
    }
    
    cat("\nSorted mixed case list (case sensitivity varies by locale):\n")
    sorted_mixed <- sort(mixed_case)
    for (i in seq_along(sorted_mixed)) {
      cat(sprintf("Sorted case item %d: %s\n", i, sorted_mixed[i]))
    }
  })
}

shinyApp(ui = ui, server = server)
