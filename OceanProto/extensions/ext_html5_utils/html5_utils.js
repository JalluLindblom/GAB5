
function html5_download_string_as_file(string, filename)
{
    const element = document.createElement('a');
    element.href = 'data:application/text,' + encodeURIComponent(string);
    element.download = filename;
    element.click();
}
