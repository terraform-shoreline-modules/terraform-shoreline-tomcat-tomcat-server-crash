resource "shoreline_notebook" "tomcat_server_crash" {
  name       = "tomcat_server_crash"
  data       = file("${path.module}/data/tomcat_server_crash.json")
  depends_on = [shoreline_action.invoke_system_stats,shoreline_action.invoke_netstat_ping,shoreline_action.invoke_stop_start_tomcat,shoreline_action.invoke_config_memory_allocation]
}

resource "shoreline_file" "system_stats" {
  name             = "system_stats"
  input_file       = "${path.module}/data/system_stats.sh"
  md5              = filemd5("${path.module}/data/system_stats.sh")
  description      = "Check if there are any resource limitations that might be causing the crash"
  destination_path = "/agent/scripts/system_stats.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "netstat_ping" {
  name             = "netstat_ping"
  input_file       = "${path.module}/data/netstat_ping.sh"
  md5              = filemd5("${path.module}/data/netstat_ping.sh")
  description      = "Check if there are any firewall or networking issues"
  destination_path = "/agent/scripts/netstat_ping.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "stop_start_tomcat" {
  name             = "stop_start_tomcat"
  input_file       = "${path.module}/data/stop_start_tomcat.sh"
  md5              = filemd5("${path.module}/data/stop_start_tomcat.sh")
  description      = "Restart the Tomcat server to see if it comes back online."
  destination_path = "/agent/scripts/stop_start_tomcat.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "config_memory_allocation" {
  name             = "config_memory_allocation"
  input_file       = "${path.module}/data/config_memory_allocation.sh"
  md5              = filemd5("${path.module}/data/config_memory_allocation.sh")
  description      = "Verify that there is enough memory allocated to the Tomcat server and adjust as necessary."
  destination_path = "/agent/scripts/config_memory_allocation.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_system_stats" {
  name        = "invoke_system_stats"
  description = "Check if there are any resource limitations that might be causing the crash"
  command     = "`chmod +x /agent/scripts/system_stats.sh && /agent/scripts/system_stats.sh`"
  params      = []
  file_deps   = ["system_stats"]
  enabled     = true
  depends_on  = [shoreline_file.system_stats]
}

resource "shoreline_action" "invoke_netstat_ping" {
  name        = "invoke_netstat_ping"
  description = "Check if there are any firewall or networking issues"
  command     = "`chmod +x /agent/scripts/netstat_ping.sh && /agent/scripts/netstat_ping.sh`"
  params      = ["SERVER_IP"]
  file_deps   = ["netstat_ping"]
  enabled     = true
  depends_on  = [shoreline_file.netstat_ping]
}

resource "shoreline_action" "invoke_stop_start_tomcat" {
  name        = "invoke_stop_start_tomcat"
  description = "Restart the Tomcat server to see if it comes back online."
  command     = "`chmod +x /agent/scripts/stop_start_tomcat.sh && /agent/scripts/stop_start_tomcat.sh`"
  params      = []
  file_deps   = ["stop_start_tomcat"]
  enabled     = true
  depends_on  = [shoreline_file.stop_start_tomcat]
}

resource "shoreline_action" "invoke_config_memory_allocation" {
  name        = "invoke_config_memory_allocation"
  description = "Verify that there is enough memory allocated to the Tomcat server and adjust as necessary."
  command     = "`chmod +x /agent/scripts/config_memory_allocation.sh && /agent/scripts/config_memory_allocation.sh`"
  params      = ["MAXIMUM_MEMORY_ALLOCATION","PATH_TO_TOMCAT_CONFIG_FILE","MINIMUM_MEMORY_ALLOCATION"]
  file_deps   = ["config_memory_allocation"]
  enabled     = true
  depends_on  = [shoreline_file.config_memory_allocation]
}

