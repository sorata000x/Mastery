const functions = require('firebase-functions');
const axios = require('axios');

exports.callOpenAI = functions.https.onCall(async (req, res) => {
  const apiKey = functions.config().openai.key;
  
  try {
    const startTime = Date.now();
    const response = await axios.post('https://api.openai.com/v1/chat/completions', {
      model: 'gpt-4o-mini',
      messages: req.messages, // We're receiving the prompt here from the Flutter app
      functions: req.functions,
      temperature: 0,
    }, {
      headers: {
        'Authorization': `Bearer ${apiKey}`,
        'Content-Type': 'application/json',
      }
    });

    console.log(response.data);

    return response.data;
  } catch (error) {
    // Log the error for debugging
    console.error('Error calling OpenAI:', error.response ? error.response.data : error.message);

    // Return a descriptive error to the client
    throw new functions.https.HttpsError('internal', 'Error calling OpenAI API', error.response ? error.response.data : error.message);
  }
});

