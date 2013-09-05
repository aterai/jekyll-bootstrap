---
layout: post
title: JFileChooserを開いたままファイルの上書き警告ダイアログを表示する
category: swing
folder: FileAlreadyExistsDialog
tags: [JFileChooser, JOptionPane]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-07-02

## JFileChooserを開いたままファイルの上書き警告ダイアログを表示する
`JFileChooser`で名前を付けて保存する場合、すでに存在するファイルを選択してセーブボタンを押すと上書き警告ダイアログを表示するように設定します。

- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/-77H8Wl7UgV0/T_E-hZznv2I/AAAAAAAABOo/RIVqWmchCfw/s800/FileAlreadyExistsDialog.png)

### サンプルコード
<pre class="prettyprint"><code>JFileChooser fileChooser = new JFileChooser() {
  @Override public void approveSelection() {
    File f = getSelectedFile();
    if(f.exists() &amp;&amp; getDialogType() == SAVE_DIALOG) {
      String m = String.format(
          "&lt;html&gt;%s already exists.&lt;br&gt;Do you want to replace it?",
          f.getAbsolutePath());
      int rv = JOptionPane.showConfirmDialog(
          this, m, "Save As", JOptionPane.YES_NO_OPTION);
      if(rv!=JOptionPane.YES_OPTION) {
        return;
      }
    }
    super.approveSelection();
  }
};
</code></pre>

### 解説
上記のサンプルでは、ユーザーが`Save`ボタンをクリックした時に呼び出される`JFileChooser#approveSelection()`をオーバーライドし、選択されているファイルがすでに存在する場合は、上書きしても良いかを確認する`ConfirmDialog`を`JFileChooser`を親にして呼び出しています。`Yes`の場合は、`super.approveSelection()`を実行して結果を返して`JFileChooser`を閉じる、`No`の場合は、なにもせずに`JFileChooser`に戻ります。

- 注: このサンプルでは上書きするを選択した場合でも、選択したファイル名をコンソールに出力するだけで、実際にファイルを保存する機能はありません。

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Swing - How to react on events fired by a JFileChooser?](https://forums.oracle.com/thread/1391852)
- [java - JFileChooser with confirmation dialog - Stack Overflow](http://stackoverflow.com/questions/3651494/jfilechooser-with-confirmation-dialog)

<!-- dummy comment line for breaking list -->

### コメント
