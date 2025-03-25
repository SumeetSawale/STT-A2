# Initialize report
echo "Commit Hash, High Severity, Medium Severity, Low Severity, High Confidence, Medium Confidence, Low Confidence, Total Issues, CWEs" > bandit_report.csv

# Loop through the last 100 commits
for commit in $(git log master --no-merges --pretty=format:%H -n 100 -- "*.py"); do
    git checkout $commit 2>/dev/null
    echo "Scanning commit: $commit"

    # Run Bandit and extract JSON output
    bandit_output=$(bandit -r . --quiet --format json)

    # Extract severity counts
    high=$(echo "$bandit_output" | jq '.results | map(select(.issue_severity == "HIGH")) | length')
    medium=$(echo "$bandit_output" | jq '.results | map(select(.issue_severity == "MEDIUM")) | length')
    low=$(echo "$bandit_output" | jq '.results | map(select(.issue_severity == "LOW")) | length')
    total=$((high + medium + low))

    # Extract confidence counts
    high_conf=$(echo "$bandit_output" | jq '.results | map(select(.issue_confidence == "HIGH")) | length')
    medium_conf=$(echo "$bandit_output" | jq '.results | map(select(.issue_confidence == "MEDIUM")) | length')
    low_conf=$(echo "$bandit_output" | jq '.results | map(select(.issue_confidence == "LOW")) | length')

    # Extract CWE IDs (deduplicated)
    cwe_list=$(echo "$bandit_output" | jq -r '.results[].issue_cwe.id' | sort -u | tr '\n' ';')

    # Append to report
    echo "$commit, $high, $medium, $low, $high_conf, $medium_conf, $low_conf, $total, \"$cwe_list\"" >> bandit_report.csv
done

# Return to the latest commit
git checkout master