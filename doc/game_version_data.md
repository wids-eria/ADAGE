#Game Version Data API

All of these calls require the user making the calls be authorized as a developer or researcher on the game that this data is associated with.

##POST /game_version_data/save 

Upload the game version data for this application. This should conform to the game version data specification. This call will return and error if the game version data already exists.

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
        <td>game_version_data</td>
        <td>A JSON object containing what will be saved</td>
    </tr>
</table>


##POST /game_version_data/delete

Deletes the game version data for this game.

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

##GET /game_version_data

Returns the game version data for this game version.

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

returns the json structure that was stored
