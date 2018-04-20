task hello_task {
command {
    echo "Hello" 
  }

}

workflow map1 {
	call hello_task
}
