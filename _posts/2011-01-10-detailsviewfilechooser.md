---
layout: post
category: swing
folder: DetailsViewFileChooser
title: JFileChooserのデフォルトをDetails Viewに設定
tags: [JFileChooser, FilePane]
author: aterai
pubdate: 2011-01-10T17:02:55+09:00
description: JFileChooserを開いたときのデフォルトをリストではなく詳細に変更します。
comments: true
---
## 概要
`JFileChooser`を開いたときのデフォルトをリストではなく詳細に変更します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TSq77M-soeI/AAAAAAAAAxg/0nnen-n-cAY/s800/DetailsViewFileChooser.png %}

## サンプルコード
<pre class="prettyprint"><code>//java - How can I start the JFileChooser in the Details view? - Stack Overflow]
//http://stackoverflow.com/questions/16292502/how-can-i-start-the-jfilechooser-in-the-details-view
//for (Object key: chooser.getActionMap().allKeys()) {
//    System.out.println(key);
//}
Action detailsAction = chooser.getActionMap().get("viewTypeDetails");
if (detailsAction != null) {
  detailsAction.actionPerformed(null);
}
</code></pre>

## 解説
- 以下のリンクで紹介されているように、`ActionMap`から`viewTypeDetails`アクションを取得する方法が一番簡単なようです。
    - [java - How can I start the JFileChooser in the Details view? - Stack Overflow](http://stackoverflow.com/questions/16292502/how-can-i-start-the-jfilechooser-in-the-details-view)
    - 何時から使用できるようになったのか、それとも元から使用可能だったのかなどを調査中。

<!-- dummy comment line for breaking list -->

- - - -
`JFileChooser`の子で`UIManager.getIcon("FileChooser.detailsViewIcon")`アイコンが設定されている`JToggleButton`を検索、`doClick()`することで、`List`から`DetailsView`(詳細)に切り替える方法もあります。

<pre class="prettyprint"><code>//searchAndClick(chooser, UIManager.getIcon("FileChooser.detailsViewIcon"));
private static boolean searchAndClick(Container parent, Icon icon) {
  for (Component c:parent.getComponents()) {
    if (c instanceof JToggleButton &amp;&amp; ((JToggleButton) c).getIcon() == icon) {
      ((AbstractButton) c).doClick();
      return true;
    } else {
      if (searchAndClick((Container) c, icon)) {
        return true;
      }
    }
  }
  return false;
}
</code></pre>

- - - -
警告されますが、以下のように`sun.swing.FilePane#setViewType(sun.swing.FilePane.VIEWTYPE_DETAILS)`メソッドを使用する方法もあります。
<pre class="prettyprint"><code>FilePane filePane = (FilePane) findChildComponent(chooser, FilePane.class);
filePane.setViewType(FilePane.VIEWTYPE_DETAILS);
</code></pre>

## 参考リンク
- [java - How can I start the JFileChooser in the Details view? - Stack Overflow](http://stackoverflow.com/questions/16292502/how-can-i-start-the-jfilechooser-in-the-details-view)
- [Swing Utils « Java Tips Weblog](http://tips4java.wordpress.com/2008/11/13/swing-utils/)
    - via: [set jFileChooser default to details view - Java Forums](http://www.java-forums.org/awt-swing/13733-set-jfilechooser-default-details-view.html)
- [sun.swing: FilePane.java](http://www.docjar.com/html/api/sun/swing/FilePane.java.html)

<!-- dummy comment line for breaking list -->

## コメント
