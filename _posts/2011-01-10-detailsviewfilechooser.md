---
layout: post
category: swing
folder: DetailsViewFileChooser
title: JFileChooserのデフォルトをDetails Viewに設定
tags: [JFileChooser, FilePane]
author: aterai
pubdate: 2011-01-10T17:02:55+09:00
description: JFileChooserを開いたときのデフォルトをリストではなく詳細に変更します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TSq77M-soeI/AAAAAAAAAxg/0nnen-n-cAY/s800/DetailsViewFileChooser.png
comments: true
---
## 概要
`JFileChooser`を開いたときのデフォルトをリストではなく詳細に変更します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TSq77M-soeI/AAAAAAAAAxg/0nnen-n-cAY/s800/DetailsViewFileChooser.png %}

## サンプルコード
<pre class="prettyprint"><code>// java - How can I start the JFileChooser in the Details view? - Stack Overflow]
// https://stackoverflow.com/questions/16292502/how-can-i-start-the-jfilechooser-in-the-details-view
// for (Object key: chooser.getActionMap().allKeys()) {
//   System.out.println(key);
// }
String cmd = "viewTypeDetails";
Optional.ofNullable(chooser.getActionMap().get(cmd))
  .ifPresent(a -&gt; a.actionPerformed(new ActionEvent(e.getSource(), e.getID(), cmd)));
</code></pre>

## 解説
[java - How can I start the JFileChooser in the Details view? - Stack Overflow](https://stackoverflow.com/questions/16292502/how-can-i-start-the-jfilechooser-in-the-details-view)で紹介されている`ActionMap`から`viewTypeDetails`アクションを取得する方法が最も簡単に`DetailsView`(詳細)に切り替え可能です。

<pre class="prettyprint"><code>//@see javax/swing/plaf/basic/BasicFileChooserUI.java
ActionMap map = new ActionMapUIResource();
Action refreshAction = new UIAction(FilePane.ACTION_REFRESH) {
  public void actionPerformed(ActionEvent e) {
    getFileChooser().rescanCurrentDirectory();
  }
};
map.put(FilePane.ACTION_APPROVE_SELECTION, getApproveSelectionAction());
map.put(FilePane.ACTION_CANCEL, getCancelSelectionAction());
map.put(FilePane.ACTION_REFRESH, refreshAction);
map.put(FilePane.ACTION_CHANGE_TO_PARENT_DIRECTORY, getChangeToParentDirectoryAction());

//sun.swing.FilePane.ACTION_APPROVE_SELECTION = "approveSelection";
//sun.swing.FilePane.ACTION_CANCEL            = "cancelSelection";
//sun.swing.FilePane.ACTION_EDIT_FILE_NAME    = "editFileName";
//sun.swing.FilePane.ACTION_REFRESH           = "refresh";
//sun.swing.FilePane.ACTION_CHANGE_TO_PARENT_DIRECTORY = "Go Up";
//sun.swing.FilePane.ACTION_NEW_FOLDER        = "New Folder";
//sun.swing.FilePane.ACTION_VIEW_LIST         = "viewTypeList";
//sun.swing.FilePane.ACTION_VIEW_DETAILS      = "viewTypeDetails";
</code></pre>

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
- [java - How can I start the JFileChooser in the Details view? - Stack Overflow](https://stackoverflow.com/questions/16292502/how-can-i-start-the-jfilechooser-in-the-details-view)
- [Swing Utils « Java Tips Weblog](https://tips4java.wordpress.com/2008/11/13/swing-utils/)
    - via: [set jFileChooser default to details view - Java Forums](http://www.java-forums.org/awt-swing/13733-set-jfilechooser-default-details-view.html)
- [sun.swing: FilePane.java](http://www.docjar.com/html/api/sun/swing/FilePane.java.html)

<!-- dummy comment line for breaking list -->

## コメント
