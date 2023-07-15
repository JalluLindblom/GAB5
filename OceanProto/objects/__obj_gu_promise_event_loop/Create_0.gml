event_inherited();

/*

An event loop for executing all promise executors.

*/

queue = ds_queue_create();  /// @is {ds_queue<Promise>}