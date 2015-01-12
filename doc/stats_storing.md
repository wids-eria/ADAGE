#Stat Storing API

##POST /save_stat 

Save Stat as a key/value for a particular user and application.

###Request
<table>
    <tr> 
        <th>params</th>
        <th>description</th>
    </tr>
    <tr>
        <td>user_id</td>
        <td>User ID</td>
    </tr>
    <tr>
        <td>app_token</td>
        <td>Token that identifies the client application</td>
    </tr>
    <tr>
        <td>key</td>
        <td>The Key to identify the Stat</td>
    </tr>
    <tr>
        <td>value</td>
        <td>The Stat value to be stored, can be any data type</td>
    </tr>
</table>


##GET /get_stat

Request the value for a previously saved stat for a player for this application.

###Request
<table>
    <tr> 
        <th>params</th>
        <th>description</th>
    </tr>
    <tr>
        <td>user_id</td>
        <td>User ID</td>
    </tr>
    <tr>
        <td>app_token</td>
        <td>Token that identifies the client application</td>
    </tr>
    <tr>
        <td>key</td>
        <td>The Key to identify the Stat</td>
    </tr>
</table>

###Response
Will return the Json object with the value for the given Stat key

