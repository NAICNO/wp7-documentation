for id in {55..60}; do curl --request PUT --header "PRIVATE-TOKEN: mjKp4XnQ-N49bLUsexsJ" "https://gitlab.sigma2.no/api/v4/projects/378/merge_requests/${id}?state_event=close";done;

for id in {51..57}; do curl --request PUT --header "PRIVATE-TOKEN: mjKp4XnQ-N49bLUsexsJ" "https://gitlab.sigma2.no/api/v4/projects/378/issues/${id}?state_event=close";done;


for id in {11..19}; do curl --request DELETE --header "PRIVATE-TOKEN: 6jKrTJVrnAn7WTPvcBzs" "https://gitlab.sigma2.no/api/v4/projects/391/repository/branches/FITSM-ROBOT-${id}";done;

