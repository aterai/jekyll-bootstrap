---
layout: post
category: swing
folder: FileAlreadyExistsDialog
title: JFileChooserを開いたままファイルの上書き警告ダイアログを表示する
tags: [JFileChooser, JOptionPane]
author: aterai
pubdate: 2012-07-02T17:20:50+09:00
description: JFileChooserで名前を付けて保存する場合、すでに存在するファイルを選択してセーブボタンを押すと上書き警告ダイアログを表示するように設定します。
image: https://lh6.googleusercontent.com/-77H8Wl7UgV0/T_E-hZznv2I/AAAAAAAABOo/RIVqWmchCfw/s800/FileAlreadyExistsDialog.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2012/08/jfilechooser-with-file-already-exists.html
    lang: en
comments: true
---
## 概要
`JFileChooser`で名前を付けて保存する場合、すでに存在するファイルを選択してセーブボタンを押すと上書き警告ダイアログを表示するように設定します。

{% download https://lh6.googleusercontent.com/-77H8Wl7UgV0/T_E-hZznv2I/AAAAAAAABOo/RIVqWmchCfw/s800/FileAlreadyExistsDialog.png %}

## サンプルコード
<pre class="prettyprint"><code>JFileChooser fileChooser = new JFileChooser() {
  @Override public void approveSelection() {
    File f = getSelectedFile();
    if (f.exists() &amp;&amp; getDialogType() == SAVE_DIALOG) {
      String m = String.format(
          "&lt;html&gt;%s already exists.&lt;br&gt;Do you want to replace it?",
          f.getAbsolutePath());
      int rv = JOptionPane.showConfirmDialog(
          this, m, "Save As", JOptionPane.YES_NO_OPTION);
      if (rv != JOptionPane.YES_OPTION) {
        return;
      }
    }
    super.approveSelection();
  }
};
</code></pre>

## 解説
上記のサンプルでは、`JFileChooser`の`Save`ボタンをクリックした時に呼び出される`JFileChooser#approveSelection()`メソッドをオーバーライドし、選択されているファイルがすでに存在するかどうかをチェックしています。そのファイルが存在しない場合は通常の`JFileChooser`の処理を実行し、存在する場合は上書きしても良いかを確認する`ConfirmDialog`を`JFileChooser`を親にして呼び出します。

- `ConfirmDialog`で`Yes`をクリック
    - `super.approveSelection()`を実行して結果を返して`JFileChooser`を閉じる
    - 上記のサンプルでは、このボタンをクリックしても選択しているファイル名をコンソールに出力するだけで、実際にそのファイルを保存したり、上書きする機能は実装していない
- `ConfirmDialog`で`No`をクリック
    - なにもせずに`JFileChooser`に戻る

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Swing - How to react on events fired by a JFileChooser?](https://community.oracle.com/thread/1391852)
- [java - JFileChooser with confirmation dialog - Stack Overflow](https://stackoverflow.com/questions/3651494/jfilechooser-with-confirmation-dialog)

<!-- dummy comment line for breaking list -->

## コメント
