# GdUnit generated TestSuite
class_name SequenceRandomTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")


# TestSuite generated from
const __source = "res://addons/beehave/nodes/composites/sequence_random.gd"
const __count_up_action = "res://test/actions/count_up_action.gd"
const __blackboard = "res://addons/beehave/blackboard.gd"
const __tree = "res://addons/beehave/nodes/beehave_tree.gd"
const RANDOM_SEED = 123

var tree: BeehaveTree
var action1: ActionLeaf
var action2: ActionLeaf


func before_test() -> void:
	tree = auto_free(load(__tree).new())
	action1 = auto_free(load(__count_up_action).new())
	action2 = auto_free(load(__count_up_action).new())
	var sequence = auto_free(load(__source).new())
	sequence.random_seed = RANDOM_SEED
	var actor = auto_free(Node2D.new())
	var blackboard = auto_free(load(__blackboard).new())
	
	tree.add_child(sequence)
	sequence.add_child(action1)
	sequence.add_child(action2)
	
	tree.actor = actor
	tree.blackboard = blackboard


func test_always_executing_first_successful_node() -> void:
	var times_to_run = 2
	
	for i in range(times_to_run):
		assert_that(tree.tick()).is_equal(BeehaveNode.SUCCESS)
	
	assert_that(action1.count).is_equal(times_to_run)
	assert_that(action2.count).is_equal(times_to_run)
	
func test_execute_second_when_first_is_failing() -> void:
	var times_to_run = 2
	action1.status = BeehaveNode.FAILURE
	
	for i in range(times_to_run):
		assert_that(tree.tick()).is_equal(BeehaveNode.FAILURE)
	
	assert_that(action1.count).is_equal(2)
	assert_that(action2.count).is_equal(1)


func test_random_even_execution() -> void:
	assert_that(tree.tick()).is_equal(BeehaveNode.SUCCESS)
	assert_that(action1.count).is_equal(1)
	
	assert_that(tree.tick()).is_equal(BeehaveNode.SUCCESS)
	assert_that(action2.count).is_equal(2)


func test_return_failure_of_none_is_succeeding() -> void:
	action1.status = BeehaveNode.FAILURE
	action2.status = BeehaveNode.FAILURE
	
	assert_that(tree.tick()).is_equal(BeehaveNode.FAILURE)
	
	assert_that(action1.count).is_equal(1)
	assert_that(action2.count).is_equal(0)
