package com.example.recipe_app

import android.app.Activity
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import android.provider.OpenableColumns
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {

    private val PICK_MEDIA_REQUEST = 1
    private var result: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "media_picker").setMethodCallHandler { call, result ->
            this.result = result
            if (call.method == "pickMedia") {
                val mediaType = call.argument<String>("type")
                val intent = Intent(Intent.ACTION_PICK)
                intent.type = if (mediaType == "image") "image/*" else "video/*"
                startActivityForResult(intent, PICK_MEDIA_REQUEST)
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == PICK_MEDIA_REQUEST && resultCode == Activity.RESULT_OK) {
            val uri: Uri? = data?.data
            uri?.let {
                val filePath = getFileFromUri(uri)
                result?.success(filePath)
            } ?: result?.error("ERROR", "Failed to pick media", null)
        } else {
            result?.error("CANCELLED", "User cancelled media picking", null)
        }
    }

    private fun getFileFromUri(uri: Uri): String? {
        var filePath: String? = null
        contentResolver.query(uri, null, null, null, null)?.use { cursor ->
            val nameIndex = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
            cursor.moveToFirst()
            val fileName = cursor.getString(nameIndex)
            val file = File(cacheDir, fileName)

            try {
                contentResolver.openInputStream(uri)?.use { inputStream ->
                    FileOutputStream(file).use { outputStream ->
                        val buffer = ByteArray(1024)
                        var length: Int
                        while (inputStream.read(buffer).also { length = it } > 0) {
                            outputStream.write(buffer, 0, length)
                        }
                        filePath = file.absolutePath
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
        return filePath
    }
}
