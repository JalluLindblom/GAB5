event_inherited();

text = undefined;   /// @is {string?}

set = function(_text/*: string?*/)
{
    text = _text;
}

clear = function()
{
    text = undefined;
}