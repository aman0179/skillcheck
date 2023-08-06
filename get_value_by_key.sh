#!/bin/bash
 
get_value_by_key() {
    object=$1
    key=$2
    value=$(echo "$object" | jq -r ".$key")
    echo "$value"
}
 

#below example
object1='{"a":{"b":{"c":"d"}}}'
key1='a.b.c'
result1=$(get_value_by_key "$object1" "$key1")
echo "Result 1: $result1"
 
 
object2='{"x":{"y":{"z":"a"}}}'
key2='x.y.z'
result2=$(get_value_by_key "$object2" "$key2")
echo "Result 2: $result2"
