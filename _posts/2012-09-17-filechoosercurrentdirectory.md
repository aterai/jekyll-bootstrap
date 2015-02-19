---
layout: post
category: swing
folder: FileChooserCurrentDirectory
title: JFileChooserを開いた時のカレントディレクトリを設定する
tags: [JFileChooser]
author: aterai
pubdate: 2012-09-17T13:37:55+09:00
description: JFileChooserを開いた時のカレントディレクトリを設定します。
comments: true
---
## 概要
`JFileChooser`を開いた時のカレントディレクトリを設定します。

{% download https://lh5.googleusercontent.com/-L0xUhPSuu1Y/UFaopCvyPFI/AAAAAAAABSg/JUQJkTi-0BI/s800/FileChooserCurrentDirectory.png %}

## サンプルコード
<pre class="prettyprint"><code>File f = new File(field.getText().trim());
JFileChooser fc = check1.isSelected() ? fc2 : fc0;
fc.setCurrentDirectory(f);
int retvalue = fc.showOpenDialog(p);
if (retvalue == JFileChooser.APPROVE_OPTION) {
  log.setText(fc.getSelectedFile().getAbsolutePath());
}
</code></pre>

## 解説
`JFileChooser.DIRECTORIES_ONLY`で、ディレクトリのみ表示する場合のカレントディレクトリの設定をテストします。

- [setCurrentDirectory](http://docs.oracle.com/javase/jp/6/api/javax/swing/JFileChooser.html#setCurrentDirectory%28java.io.File%29): `JFileChooser#setCurrentDirectory(File)`で`CurrentDirectory`を設定
    - 参照:コンボボックスにディレクトリ名
    - リストには、`CurrentDirectory`内のディレクトリ一覧
    - フォルダ名: テキストフィールドは前回の文字列(`setCurrentDirectory`では変化しない)
    - 存在しないファイルを`setCurrentDirectory`で設定すると、前回の`CurrentDirectory`(初回に存在しないファイルが設定された場合は`OS`のデフォルト)が表示される
        - 上記のサンプルで、`Change !dir.exists() case`にチェックをした場合、前回のディレクトリではなく、参照可能な親ディレクトリを検索するよう、`setCurrentDirectory`をオーバーライドした`JFileChooser`を使用する
            
            <pre class="prettyprint"><code>JFileChooser fc2 = new JFileChooser() {
              @Override public void setCurrentDirectory(File dir) {
                if (dir != null &amp;&amp; !dir.exists()) {
                  this.setCurrentDirectory(dir.getParentFile());
                }
                super.setCurrentDirectory(dir);
              }
            };
</code></pre>
- [setSelectedFile](http://docs.oracle.com/javase/jp/6/api/javax/swing/JFileChooser.html#setSelectedFile%28java.io.File%29): `JFileChooser#setSelectedFile(File)`で選択ファイルとしてディレクトリを設定
    - 参照: コンボボックスには、選択ファイルとして設定したディレクトリの親ディレクトリ名
    - リストには、親ディレクトリ内のディレクトリ一覧
        - `Metal`や`Nimbus LookAndFeel`では、選択ファイルとして設定したディレクトリが選択状態になる
        - `Metal`などの`LookAndFeel`でも、ディレクトリが選択状態にならない場合がある
        - 上記のサンプルで、`isParent reset?`にチェックをした場合、`!fileChooser.getFileSystemView().isParent(fileChooser.getCurrentDirectory(), dir)==false`になるように？`setSelectedFile`で選択ファイルをリセットする
    - フォルダ名:テキストフィールドは選択ファイルとして設定したディレクトリ
    - 存在しないディレクトリを`setSelectedFile`で設定するとその親ディレクトリ、親ディレクトリも存在しない場合は、`OS`のデフォルトがカレントディレクトリとなる

<!-- dummy comment line for breaking list -->

## コメント
