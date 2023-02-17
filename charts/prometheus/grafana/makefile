# https://grafana.com/grafana/dashboards/14828
deploy_gatekeeper_dashboard_configmap:
	kubectl -n promstack delete cm grafana-gatekeeper-dashboard ||:
	kubectl -n promstack create cm grafana-gatekeeper-dashboard --from-file=./grafana/gatekeeper-dashboard.json
	kubectl -n promstack label cm grafana-gatekeeper-dashboard grafana_dashboard=1

create_gatekeeper_dashboard_files:
	@echo "Creating configmap:\n  ./cm-gatekeeper-dashboard.yaml\nfrom dahsboard JSON file:\n  ./gatekeeper-dashboard.json"
	@kubectl -n promstack create cm grafana-gatekeeper-dashboard \
		--from-file=./gatekeeper-dashboard.json --dry-run=client -oyaml \
		| kubectl label -f- --dry-run=client -oyaml --local grafana_dashboard=1 \
		> ./cm-gatekeeper-dashboard.yaml
	@echo "\nCreating chart template file:\n  ../chart-prometheus-extras/templates/cm-gatekeeper-dashboard.yaml\nfrom configmap:\n  ./cm-gatekeeper-dashboard.yaml"
	@cat ./cm-gatekeeper-dashboard.yaml \
		| sed 's/{{/{{\` {{/g' \
		| sed 's/}}/}} \`}}/g' \
		> ../chart-prometheus-extras/templates/cm-gatekeeper-dashboard.yaml