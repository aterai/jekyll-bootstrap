---
layout: post
category: swing
folder: DragEnabledTextComponent
title: JTextFieldのドラッグ＆ドロップ設定をテストする
tags: [JTextField, DragAndDrop, TransferHandler]
author: aterai
pubdate: 2017-10-30T15:36:53+09:00
description: JTextFieldが初期状態や編集不可の場合などでドラッグ＆ドロップをテストします。
image: https://drive.google.com/uc?id=1bHJS4TOFW3wUg-zz4Ut_gnrS2vYNXKE_Vg
comments: true
---
## 概要
`JTextField`が初期状態や編集不可の場合などでドラッグ＆ドロップをテストします。

{% download https://drive.google.com/uc?id=1bHJS4TOFW3wUg-zz4Ut_gnrS2vYNXKE_Vg %}

## サンプルコード
<pre class="prettyprint"><code>JTextField textField0 = new JTextField("Initially has BasicTextUI$TextTransferHandler");
textField0.setDragEnabled(true);

JTextField textField1 = new JTextField("setEditable(false)");
textField1.setDragEnabled(true);
textField1.setEditable(false);

JTextField textField2 = new JTextField("setEnabled(false)");
textField2.setDragEnabled(true);
textField2.setEnabled(false);

JTextField textField3 = new JTextField("setTransferHandler(null)");
textField3.setDragEnabled(true);
textField3.setTransferHandler(null);

JTextField textField4 = new JTextField("setDropTarget(null)");
textField4.setDragEnabled(true);
textField4.setDropTarget(null);

JTextField textField5 = new JTextField("TransferHandler#canImport(...): false");
textField5.setDragEnabled(true);
textField5.setTransferHandler(new TransferHandler() {
    @Override public boolean canImport(TransferSupport info) {
        return false;
    }
});
</code></pre>

## 解説
- `0`: `Initially has BasicTextUI$TextTransferHandler`
    - 初期状態で、`BasicTextUI$TextTransferHandler`が設定されている
        - このため、例えばワードパットなどから文字列をドラッグ＆ドロップで移動(<kbd>Ctrl+ドロップ</kbd>でコピー)可能
        - `BasicTextUI$TextTransferHandler`はファイルなどのドロップには対応していない
    - `JTextField#setDragEnabled(true)`を設定しているので、他の`JTextComponent`や自分自身にドラッグ＆ドロップで移動・コピーが可能
- `1`: `setEditable(false)`
    - 初期状態で、`BasicTextUI$TextTransferHandler`が設定されている
    - `JTextField#setEditable(false)`を設定した場合、ドロップ不可となる
    - `JTextField#setEditable(false)`かつ`JTextField#setDragEnabled(true)`の場合、選択文字列を他の`JTextComponent`にドラッグ＆ドロップでコピー可能(移動は不可)
- `2`: `setEnabled(false)`
    - 初期状態で、`BasicTextUI$TextTransferHandler`が設定されている
    - `JTextField#setEnabled(false)`で使用不可のコンポーネントにはドラッグ＆ドロップ不可
    - `JTextField#setDragEnabled(true)`を設定しても文字列選択不可なので、`BasicTextUI$TextTransferHandler`ではドラッグ自体が開始できない
- `3`: `setTransferHandler(null)`
    - `JTextField#setTransferHandler(null)`で`BasicTextUI$TextTransferHandler`を削除
    - 親コンポーネントの`TransferHandler`が有効になる
        - このサンプルの場合は、`JFrame`に設定したダミー`TransferHandler`
- `4`: `setDropTarget(null)`
    - `JTextField#setDropTarget(null)`でこのコンポーネントに関連付けされた`DropTarget`をクリア
    - 親コンポーネントの`DropTarget`が有効になる
        - このサンプルの場合は、`JFrame`に設定したダミー`TransferHandler`の`DropTarget`
- `5`: `TransferHandler#canImport(...): false`
    - `TransferHandler#canImport(...)`が常に`false`を返す`TransferHandler`を設定
    - 親コンポーネントの`TransferHandler`にドロップイベントは伝搬せず、常にドロップ不可
    - `JTextField#setDragEnabled(true)`を設定してもこの`TransferHandler`ではドラッグ開始できない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Component#setDropTarget(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Component.html#setDropTarget-java.awt.dnd.DropTarget-)
- [Default DnD Support (The Java™ Tutorials > Creating a GUI With JFC/Swing > Drag and Drop and Data Transfer)](https://docs.oracle.com/javase/tutorial/uiswing/dnd/defaultsupport.html)

<!-- dummy comment line for breaking list -->

## コメント
