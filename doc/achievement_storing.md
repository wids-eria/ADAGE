#Achievement Storing API

##POST /save_achievement 

Save achievement as a key/value for a particular user and application.

###Request
<table>
    <tr> 
        <th>params</th>
        <th>description</th>
    </tr>
    <tr>
        <td>access_token</td>
        <td>The secret access token for that specific user and application</td>
    </tr>
    <tr>
        <td>key</td>
        <td>The Key to identify the achievement</td>
    </tr>
    <tr>
        <td>value</td>
        <td>The achievement value to be stored, can be any data type</td>
    </tr>
</table>


##GET /get_achievement

Request the value for a previously saved achievement for a player for this application.

###Request
<table>
    <tr> 
        <th>params</th>
        <th>description</th>
    </tr>
    <tr>
        <td>access_token</td>
        <td>The secret access token for the specific user and application</td>
    </tr>
    <tr>
        <td>key</td>
        <td>The Key to identify the achievement</td>
    </tr>
</table>

###Response
Will return the Json object with the value for the given achievement key

##GET /get_achievements

Request all of the achievements for a player for this application.

###Request
<table>
    <tr> 
        <th>params</th>
        <th>description</th>
    </tr>
    <tr>
        <td>access_token</td>
        <td>The secret access token for the specific user and application</td>
    </tr>
</table>

###Response
Will return the Json object with all of the achievements key/values