/* 
 * File module for JsMobileBasic.
 * Help: https://vk.com/page-123026568_53604956
 * Supports:
 *  Node FS [+]
 *  JsOS FS [+]
 *  Browser pseudo-fs [-]
 */
'use strict';

let $File, $Path;

if (typeof require === "function") { //JsOS or Node
    $File = require('fs');
    $Path = require('path');
} else if (typeof localStorage !== "undefined") { //Browser
    //TODO: Add browser support
    throw new Error("At this time, the browser is not supported!");
} else {
    throw new Error("Your system doesn't support FileSystem");
}

/* eslint-disable */

function saveData(filename, data, callback) {
    if (!$NW) return !!console.error("Can't find base path");
    const filePath = $Path.join($NW.App.dataPath, `${filename}.json`);
    try {
        $File.writeFileSync(filePath, toJSON(data), "utf8");
        return true;
    } catch (e) {
        console.error("Ошибка записи данных: ", e);
        return false;
    }
}

function readData(filename) {
    if (!$NW) return !!console.error("Can't find base path");
    var filePath = $Path.join($NW.App.dataPath, `${filename}.json`);
    let data = null;
    try {
        data = $File.readFileSync(filePath, 'utf8');
    } catch (e) {
        console.error("Ошибка чтения данных: ", e);
        return false;
    }
    let json = null;
    try {
        json = parseJSON(data);
    } catch (e) {}
    return json || data;
}