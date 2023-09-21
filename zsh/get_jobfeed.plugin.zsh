function get_jobfeed {
  errPrint () {
    print >&2 "[ERROR]:" $@
  }
  infPrint () {
    print >&2 "[NOTICE]:" $@
  }

  local now=$(date '+%Y.%m.%d.%H%M%S')
  local filename="jobFeed_${1}_${now}.json"

  local argv=(${(@s/-/)1})

  local response=$(curl --silent --request GET \
    --url "https://scrape.paradox.ai/api/v1/feeds/get-presigned-url?company_id=${argv[1]}&company_scrape_id=${argv[2]}" \
    --header "API-clientid: " \
    --header "API-timestamp: " \
    --header "API-token: " \
    --data "{\"company_id\": \"${argv[1]}\",\"company_scrape_id\": \"${argv[2]}\",}"
  )

  local message=$(print "$response " | jq --raw-output '.message')
  local data=$(print "$response " | jq --raw-output '.data')

  if [ "$message" = 'success' ]; then
    wget -qO "$filename" "$data"
    if [ -f "$filename" ]; then
      infPrint $filename
      cat "$filename" | jq > ".tmp"
      mv ".tmp" "$filename"
    else
      errPrint "file '${filename}' does not exist"
    fi
  else
    errPrint "message: ${message}"
    errPrint "data: ${data}"
  fi
}
