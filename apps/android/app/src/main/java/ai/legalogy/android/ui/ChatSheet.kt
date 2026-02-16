package ai.legalogy.android.ui

import androidx.compose.runtime.Composable
import ai.legalogy.android.MainViewModel
import ai.legalogy.android.ui.chat.ChatSheetContent

@Composable
fun ChatSheet(viewModel: MainViewModel) {
  ChatSheetContent(viewModel = viewModel)
}
