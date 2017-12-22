---
layout: post
category: swing
folder: FileHidingEnabled
title: JFileChooserでの隠しファイルの非表示設定を変更する
tags: [JFileChooser, JPopupMenu]
author: aterai
pubdate: 2014-03-17T00:01:02+09:00
description: JFileChooserで隠しファイルを表示するかどうかをポップアップメニューから切り替えます。
image: https://lh4.googleusercontent.com/-TSMPljQ02Ao/UyWixahVFzI/AAAAAAAACBw/n_Ctee0FJGQ/s800/FileHidingEnabled.png
comments: true
---
## 概要
`JFileChooser`で隠しファイルを表示するかどうかをポップアップメニューから切り替えます。

{% download https://lh4.googleusercontent.com/-TSMPljQ02Ao/UyWixahVFzI/AAAAAAAACBw/n_Ctee0FJGQ/s800/FileHidingEnabled.png %}

## サンプルコード
<pre class="prettyprint"><code>chooser = new JFileChooser();
JPopupMenu pop = searchPopupMenu(chooser);
pop.addSeparator();
JCheckBoxMenuItem mi = new JCheckBoxMenuItem(new AbstractAction("isFileHidingEnabled") {
  @Override public void actionPerformed(ActionEvent e) {
    chooser.setFileHidingEnabled(((JCheckBoxMenuItem) e.getSource()).isSelected());
  }
});
mi.setSelected(chooser.isFileHidingEnabled());
pop.add(mi);
</code></pre>

## 解説
上記のサンプルでは、`JFileChooser#setFileHidingEnabled(boolean)`メソッドを使用して、隠しファイル、隠しフォルダーなどの表示・非表示を設定しています。

- `JFileChooser`からファイルリストの`JPopupMenu`を直接取得することが出来ないので、子コンポーネントを検索する必要がある
    - 参考: [Containerの子Componentを再帰的にすべて取得する](https://ateraimemo.com/Swing/GetComponentsRecursively.html)
- 初期値は、`OS`の設定(`Windows`なら「コントロールパネル、フォルダーオプション、表示、ファイルとフォルダーの表示」)に従う
    - 参考: [DesktopPropertyの変更を監視する](https://ateraimemo.com/Swing/DesktopProperty.html)
        
        <pre class="prettyprint"><code>Object showHiddenProperty = Toolkit.getDefaultToolkit().getDesktopProperty("awt.file.showHiddenFiles");
        System.out.println("awt.file.showHiddenFiles: " + showHiddenProperty);
</code></pre>
    - * 参考リンク [#reference]
- [クロノス・クラウン - 「JFileChooser」のコンテキストメニューに独自メニューを追加する方法](http://crocro.com/news/20110706140746.html)
- [DesktopPropertyの変更を監視する](https://ateraimemo.com/Swing/DesktopProperty.html)
- [Containerの子Componentを再帰的にすべて取得する](https://ateraimemo.com/Swing/GetComponentsRecursively.html)

<!-- dummy comment line for breaking list -->

## コメント
