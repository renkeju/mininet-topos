#!/usr/bin/env bash

python_script_index=1
python_scripts_array=($(ls topos | egrep *.py | cut -f 1 -d "."))
onos_host_index=1
onos_hosts_array=($(env | egrep "OC[1-9]{1}"|cut -f 2 -d "="))

function select_py () {
echo "Select the topology number listed below: "
for python_script in ${python_scripts_array[@]}
do
    echo "${python_script_index}) ${python_script}"
    ((python_script_index+=1))
done

read -p "Enter topology number: " TOPO_NUM
PYTHON_SCRIPT_ARRAY_INDEX=$((TOPO_NUM-1))

if [ ${PYTHON_SCRIPT_ARRAY_INDEX} -ge 0 -a ${PYTHON_SCRIPT_ARRAY_INDEX} -lt ${#python_scripts_array[@]} ]; then
    echo -e "\033[33mselect python script is ${python_scripts_array[${PYTHON_SCRIPT_ARRAY_INDEX}]}.py\033[0m"
else
    echo -e "\033[31m${TOPO_NUM} Is a nonexistent topology number!\033[0m"
    select_py
fi
}

function select_oc () {
echo "Select the onos host target number: "
for onos_host in ${onos_hosts_array[@]}
do
    echo "${onos_host_index}) ${onos_host}"
    ((onos_host_index+=1))
done

read -p "Enter onos host number: " HOST_NUM
ONOS_HOST_ARRAY_INDEX=$((HOST_NUM-1))

if [ ${ONOS_HOST_ARRAY_INDEX} -ge 0 -a ${ONOS_HOST_ARRAY_INDEX} -lt ${#onos_hosts_array[@]} ]; then
    echo -e "\033[33mselect onos host ip is ${onos_hosts_array[${ONOS_HOST_ARRAY_INDEX}]}\033[0m"
else
    echo -e "\033[31m${HOST_NUM} Is a nonexistent host number!\033[0m"
    select_oc
fi
}

function run () {
echo -e "\033[32m
mn --custom topos/${python_scripts_array[${PYTHON_SCRIPT_ARRAY_INDEX}]}.py \
--topo ${python_scripts_array[${PYTHON_SCRIPT_ARRAY_INDEX}]} \
--controller=remote,ip=${onos_hosts_array[${ONOS_HOST_ARRAY_INDEX}]},port=6633
\033[0m
"
mn --custom topos/${python_scripts_array[${PYTHON_SCRIPT_ARRAY_INDEX}]}.py \
--topo ${python_scripts_array[${PYTHON_SCRIPT_ARRAY_INDEX}]} \
--controller=remote,ip=${onos_hosts_array[${ONOS_HOST_ARRAY_INDEX}]},port=6633
}

select_py
select_oc
run
