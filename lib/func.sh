check_result() {
  if [ -n "$1" ]; then
    echo "DONE"
  else
    echo "FAIL"
  fi
}

check_result_for_res() {
  if [ -n "$1" ]; then
    echo "DONE"
    res=
  else
    echo "FAIL"
  fi
}

