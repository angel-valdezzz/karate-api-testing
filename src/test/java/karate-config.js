function fn() {
  var base = java.lang.System.getenv('DEMO_BASE_URL');
  var key = java.lang.System.getenv('DEMO_API_KEY');
  if (!base || !key) throw 'Use scripts/run.py --local-api or configure the API environment';
  karate.configure('logPrettyRequest', false); karate.configure('logPrettyResponse', false);
  karate.configure('report', { showLog: false, showAllSteps: true });
  karate.configure('headers', { 'X-API-Key': key });
  karate.configure('afterScenario', function() {
    var ids = karate.get('createdIds') || [];
    karate.set('createdIds', []);
    if (ids.length) karate.call('classpath:examples/cleanup.feature', ids.map(function(id) { return { id: id }; }));
  });
  return { baseUrl: base, apiKey: key };
}
