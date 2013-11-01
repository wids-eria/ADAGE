#Save Game API

##POST /save_game 

Save game information as a json object. Will save one record per player per applications. First call will create the record and subsequent calls will overwrite the saved record.

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
        <td>save_game</td>
        <td>A JSON object containing what will be saved</td>
    </tr>
</table>


##GET /load_game

Request a previously saved game for a player for this applicaiton.

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
Will return the Json object that was preivously stored for this player from this applicaiton or nothing if there was no peviously saved game

