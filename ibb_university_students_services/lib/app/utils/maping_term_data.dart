String mappingTerms(String? term){
  if(term == "Term 1") {
    return "1St";
  } else if (term == "Term 2") {
    return "2ec";
  } else {
    return "Unknown";
  }
}


int termIndex(String? term){
  if(term == "Term 1") {
    return 0;
  } else if (term == "Term 2") {
    return 1;
  } else {
    return -1;
  }
}