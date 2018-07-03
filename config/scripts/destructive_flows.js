load('nashorn:mozilla_compat.js');
importClass(java.io.File);

/**
 * Obtains all flow files from the given directory
 */
function getAllFlowFiles(directory) {
  // Obtain all Flows
  fs = project.createDataType('fileset');
  fs.setDir(new File(directory));
  fs.setIncludes('*.flow'); 
  return fs.getDirectoryScanner(project).getIncludedFiles();
}

/**
 * Generates a well-formatted Package XML based upon the given list of flow
 * files.
 */
function generateDestructiveContent(flowFiles) {
  var members = [];
  members.push('<?xml version="1.0"?>');
  members.push('<Package xmlns="http://soap.sforce.com/2006/04/metadata">');
  members.push('  <types>');

  for (i = 0; i < flowFiles.length; i++) {
    members.push('    <members>' + flowFiles[i].replace('.flow', '') + '</members>');
  }
  
  members.push('    <name>Flow</name>');
  members.push('  </types>');
  members.push('  <version>37.0</version>');
  members.push('</Package>');

  return members.join(project.getProperty('line.separator'));
}

/**
 * Main Entry Point
 */
var flowFiles = getAllFlowFiles('src/flows');
var outputFile = new File(project.getProperty('destructiveFlowsXml'));

echo = project.createTask("echo");
echo.setMessage(generateDestructiveContent(flowFiles));
echo.setFile(outputFile);
echo.perform();
