---
layout: post
title: JFileChooserでの隠しファイルの非表示設定を変更する
category: swing
folder: FileHidingEnabled
tags: [JFileChooser, JPopupMenu]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-03-17

## 概要
`JFileChooser`で隠しファイルを表示するかどうかをポップアップメニューから切り替えます。

{% download https://lh4.googleusercontent.com/-TSMPljQ02Ao/UyWixahVFzI/AAAAAAAACBw/n_Ctee0FJGQ/s800/FileHidingEnabled.png %}

## サンプルコード
<pre class="prettyprint"><code>chooser = new JFileChooser();
JPopupMenu pop = searchPopupMenu(chooser);
pop.addSeparator();
JCheckBoxMenuItem mi = new JCheckBoxMenuItem(
    new AbstractAction("isFileHidingEnabled") {
  @Override public void actionPerformed(ActionEvent e) {
    chooser.setFileHidingEnabled(
        ((JCheckBoxMenuItem) e.getSource()).isSelected());
  }
});
mi.setSelected(chooser.isFileHidingEnabled());
pop.add(mi);
</code></pre>

## 解説
上記のサンプルでは、`JFileChooser#setFileHidingEnabled(boolean)`メソッドを使用して、隠しファイル、隠しフォルダーなどを表示するかどうかを設定しています。

- - - -
- 初期値は、`OS`の設定(`Windows`なら「コントロールパネル、フォルダーオプション、表示、ファイルとフォルダーの表示」)に従う
    - 参考: [DesktopPropertyの変更を監視する](http://terai.xrea.jp/Swing/DesktopProperty.html)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>Object showHiddenProperty = Toolkit.getDefaultToolkit().getDesktopProperty("awt.file.showHiddenFiles");
System.out.println("awt.file.showHiddenFiles: " + showHiddenProperty);
</code></pre>

- - - -
`JFileChooser`から`JPopupMenu`を直接取得することが出来ないので、以下のように子コンポーネントを検索しています。

<pre class="prettyprint"><code>private static JPopupMenu searchPopupMenu(Container parent) {
  for (Component c: parent.getComponents()) {
    if (c instanceof JComponent &amp;&amp; ((JComponent) c).getComponentPopupMenu() != null) {
      return ((JComponent) c).getComponentPopupMenu();
    } else {
      JPopupMenu pop = searchPopupMenu((Container) c);
      if (pop != null) {
        return pop;
      }
    }
  }
  return null;
}
</code></pre>

## 参考リンク
- [クロノス・クラウン - 「JFileChooser」のコンテキストメニューに独自メニューを追加する方法](http://crocro.com/news/20110706140746.html)
- [DesktopPropertyの変更を監視する](http://terai.xrea.jp/Swing/DesktopProperty.html)

<!-- dummy comment line for breaking list -->

## コメント
