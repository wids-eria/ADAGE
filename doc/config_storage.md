#Config file storage API

##POST /save_config

Save config file as a json object. Will save one record per application version. First call will create the record and subsequent calls will overwrite the config record.

###Request
<table>
    <tr> 
        <th>params</th>
        <th>description</th>
    </tr>
    <tr>
        <td>app_token</td>
        <td>Token that identifies the client application</td>
    </tr>
    <tr>
        <td>config_file</td>
        <td>A JSON object containing what will be saved</td>
    </tr>
</table>


##GET /load_config

Request the config file for this application version

###Request
<table>
    <tr> 
        <th>params</th>
        <th>description</th>
    </tr>
    <tr>
        <td>app_token</td>
        <td>Token that identifies the client application</td>
    </tr>
</table>

###Response
Will return the Json object that was preivously stored this application version or nothing if there was no peviously saved game

