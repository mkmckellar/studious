fxn1 <- function(num1, num2){
  # a simple function that checks if two elements are numeric
  # and adds them together, else returns error message
  if(is.numeric(num1) & is.numeric(num2)){
    return(num1 + num2)
  }else{
    print("One or both elements are not numeric.")
  }
}
