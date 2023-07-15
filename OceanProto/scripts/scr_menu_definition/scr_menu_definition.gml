
function MenuDefinition(
    _header_entries/*: MenuEntryDefinition[]*/,
    _body_entries/*: MenuEntryDefinition[]*/,
    _footer_entries/*: MenuEntryDefinition[]*/
) constructor
{
    header_entries = _header_entries; /// @is {MenuEntryDefinition[]}
    body_entries = _body_entries;     /// @is {MenuEntryDefinition[]}
    footer_entries = _footer_entries; /// @is {MenuEntryDefinition[]}
    
    /// Invoked when an instance of this menu is freed.
    /// Event parameters: (none)
    free_event = new Event();    /// @is {Event}
    
    static create_instance = function() /*-> Menu*/
    {
        return new Menu(self);
    }
}
