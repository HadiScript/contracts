// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

contract Twitter {
    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 createdAt;
    }

    struct Message {
        uint256 id;
        string content;
        address from;
        address to;
        uint256 createdAt;
    }

    mapping(uint256 => Tweet) private tweets;
    uint256 private nextTweetId;

    mapping(address => uint256[]) private tweetOf;

    mapping(uint256 => Message[]) private conversations;
    uint256 private nextMessagegId;

    // hadi follow => [abbas, ali, ..]
    mapping(address => address[]) private following;

    event TweetSent(
        uint256 id,
        address indexed author, // agar ham yahan indexed laga dein tou-> address se data filter kar sakte hein phir hamy tweetOf ki zrorat nahi paray gi
        string content,
        uint256 createdAt
    );

    // we can just enter indexed with three fields
    event MessageSent(
        uint256 id,
        string content,
        address indexed from,
        address indexed to,
        uint256 createdAt
    );

    function tweet(string calldata _content) external {
        tweets[nextTweetId] = Tweet(
            nextTweetId,
            msg.sender,
            _content,
            block.timestamp
        );
        tweetOf[msg.sender].push(nextTweetId);
        emit TweetSent(nextTweetId, msg.sender, _content, block.timestamp);
        nextTweetId++;
    }

    function sendMessage(
        string calldata _content,
        address _from,
        address _to
    ) external {
        uint256 conversationId = uint256(uint160(_from)) +
            uint256(uint160(_to));

        conversations[conversationId].push(
            Message(nextMessagegId, _content, _from, _to, block.timestamp)
        );

        emit MessageSent(nextMessagegId, _content, _from, _to, block.timestamp);

        nextMessagegId++;
    }

    function follow(address _followed) external {
        following[msg.sender].push(_followed);
    }

    function getLatestTweets(uint256 count)
        external
        view
        returns (Tweet[] memory)
    {
        require(count > 0 && count <= nextTweetId, "not make sense");

        // now creating an array for tweet with lenght of tweetNextId;
        Tweet[] memory _tweets = new Tweet[](count);

        // for loop, to iterate tweet mapping;
        for (uint256 i = nextTweetId - count; i < nextTweetId; i++) {
            Tweet storage _tweet = tweets[i];
            _tweets[i] = Tweet(
                _tweet.id,
                _tweet.author,
                _tweet.content,
                _tweet.createdAt
            );
            // _tweets.push(tweets[i]);
        }
        return _tweets;
    }

    function getTweetsOf(address _user, uint256 count)
        external
        view
        returns (Tweet[] memory)
    {
        uint256[] storage tweetIds = tweetOf[_user];
        require(count > 0 && count <= tweetIds.length, "not make sense");

        Tweet[] memory _tweets = new Tweet[](count);

        for (uint256 i = tweetIds.length - count; i < tweetIds.length; i++) {
            Tweet storage _tweet = tweets[tweetIds[i]];
            _tweets[i] = Tweet(
                _tweet.id,
                _tweet.author,
                _tweet.content,
                _tweet.createdAt
            );
            // _tweets.push(tweets[i]);
        }
        return _tweets;
    }
}
