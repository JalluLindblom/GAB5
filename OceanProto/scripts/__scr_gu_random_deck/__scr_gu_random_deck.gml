
/// @param {any} ...elements
function RandomDeck() constructor
{
    _elements = array_create(argument_count);    /// @is {any[]}
    for (var i = 0; i < argument_count; ++i) {
        _elements[@ i] = argument[i];
    }
    _numElements = array_length(_elements);       /// @is {int}
    
    _runningIndex = 0;   /// @is {int}
    
    static draw_one = function(rng/*: Rng*/, defaultValue/*: any*/ = undefined) /*-> any*/
    {
        if (_numElements <= 0) {
            return defaultValue;
        }
        if (_runningIndex == 0) {
            rng.rng_array_shuffle(_elements);
        }
        var value = _elements[@ _runningIndex];
        ++_runningIndex;
        if (_runningIndex >= _numElements) {
            _runningIndex = 0;
        }
        return value;
    }
    
    static get_size = function() /*-> int*/
    {
        return _numElements;
    }
}

function random_deck_from_array(array/*: Array*/) /*-> RandomDeck*/
{
    var deck = new RandomDeck();
    array_copy(deck._elements, 0, array, 0, array_length(array));
    deck._numElements = array_length(array);
    return deck;
}
