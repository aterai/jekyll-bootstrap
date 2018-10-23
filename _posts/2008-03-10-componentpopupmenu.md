---
layout: post
category: swing
folder: ComponentPopupMenu
title: JPopupMenuをコンポーネントに追加
tags: [JPopupMenu, JTextComponent, PopupMenuListener, DefaultEditorKit]
author: aterai
pubdate: 2008-03-10T01:39:57+09:00
description: コンポーネントに右クリックなどでポップアップするJPopupMenuを追加します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTKBw4_YtI/AAAAAAAAAVU/J_aFRLSj-VU/s800/ComponentPopupMenu.png
comments: true
---
## 概要
コンポーネントに右クリックなどでポップアップする`JPopupMenu`を追加します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTKBw4_YtI/AAAAAAAAAVU/J_aFRLSj-VU/s800/ComponentPopupMenu.png %}

## サンプルコード
<pre class="prettyprint"><code>JTextArea textArea = new JTextArea("ComponentPopupMenu Test");
textArea.setComponentPopupMenu(new TextComponentPopupMenu());
</code></pre>
<pre class="prettyprint"><code>class TextComponentPopupMenu extends JPopupMenu {
  private final Action cutAction = new DefaultEditorKit.CutAction();
  private final Action copyAction = new DefaultEditorKit.CopyAction();
  private final Action pasteAction = new DefaultEditorKit.PasteAction();
  private final Action deleteAction;
  private final Action selectAllAction;
  public TextComponentPopupMenu() {
    super();
    add(cutAction);
    add(copyAction);
    add(pasteAction);
    addSeparator();
    add(deleteAction = new AbstractAction("delete") {
      @Override public void actionPerformed(ActionEvent evt) {
        ((JTextComponent) getInvoker()).replaceSelection(null);
      }
    });
    addSeparator();
    add(selectAllAction = new AbstractAction("select all") {
      @Override public void actionPerformed(ActionEvent evt) {
        ((JTextComponent) getInvoker()).selectAll();
      }
    });
    //ActionMap am = textArea.getActionMap();
    //add(cutAction = am.get("cut-to-clipboard"));
    //add(copyAction = am.get("copy-to-clipboard"));
    //add(am.get("paste-from-clipboard"));
    //addSeparator();
    //add(deleteAction = am.get("delete-next"));
    //addSeparator();
    //add(am.get("select-all"));
  }
  @Override public void show(Component c, int x, int y) {
    JTextComponent textArea = (JTextComponent) c;
    boolean flg = textArea.getSelectedText() != null;
    cutAction.setEnabled(flg);
    copyAction.setEnabled(flg);
    deleteAction.setEnabled(flg);
    super.show(c, x, y);
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JTextArea`に`setComponentPopupMenu(JPopupMenu)`メソッドで、ポップアップメニューを追加しています。

`JDK 1.5`でこのメソッドが追加されたため、各コンポーネントにマウスリスナーを設定して、`e.isPopupTrigger()`でポップアップを表示するクリックかを判断するといったコードを書く必要が無くなりました。

ポップアップメニューを表示するときに、コンポーネントの状態(例えば`JTable`や`JList`などでの行選択の有無や、テキストが選択されてるかとどうかなどの条件)で、メニューが実行可か不可かを変更したい場合は、`JPopupMenu#show(Component, int, int)`メソッドをオーバーライドして使用します。

このサンプルでは、テキストが選択されている場合だけ、カット、コピー、削除メニューが有効になるよう設定しています。

- - - -
`JPopupMenu#show(Component, int, int)`のオーバーライドではなく、`PopupMenuListener`を使用する方法もあります。

<pre class="prettyprint"><code>JPopupMenu popup = new JPopupMenu();
final Action cutAction = new DefaultEditorKit.CutAction();
final Action copyAction = new DefaultEditorKit.CopyAction();
final Action pasteAction = new DefaultEditorKit.PasteAction();
final Action deleteAction = new AbstractAction("delete") {
  @Override public void actionPerformed(ActionEvent e) {
    ((JTextComponent) getInvoker()).replaceSelection(null);
  }
};
final Action selectAllAction = new AbstractAction("select all") {
  @Override public void actionPerformed(ActionEvent e) {
    JPopupMenu p = (JPopupMenu) e.getSource();
    ((JTextComponent) p.getInvoker()).selectAll();
  }
};
popup.add(cutAction);
popup.add(copyAction);
popup.add(pasteAction);
popup.addSeparator();
popup.add(deleteAction);
popup.addSeparator();
popup.add(selectAllAction);
popup.addPopupMenuListener(new PopupMenuListener() {
  @Override public void popupMenuCanceled(PopupMenuEvent e) {}
  @Override public void popupMenuWillBecomeInvisible(PopupMenuEvent e) {}
  @Override public void popupMenuWillBecomeVisible(PopupMenuEvent e) {
    JPopupMenu p = (JPopupMenu) e.getSource();
    JTextComponent c = (JTextComponent) p.getInvoker();
    boolean flg = c.getSelectedText() != null;
    cutAction.setEnabled(flg);
    copyAction.setEnabled(flg);
    deleteAction.setEnabled(flg);
  }
});
textArea.setComponentPopupMenu(popup);
</code></pre>

- 注: `PopupMenuEvent`からはマウスでクリックした位置を取得できない
    - このため、`JTabbedPane`などでどのタブの上でポップアップが表示されるかなどを取得したい場合は`JPopupMenu#show(...)`をオーバーライドする必要がある
    - 参考: [JTabbedPaneでタブを追加削除](https://ateraimemo.com/Swing/TabbedPane.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JPopupMenuの取得を親に委譲](https://ateraimemo.com/Swing/InheritsPopupMenu.html)
- [JTabbedPaneでタブを追加削除](https://ateraimemo.com/Swing/TabbedPane.html)

<!-- dummy comment line for breaking list -->

## コメント
- メモ: [Bug ID: 6675802 Regression: heavyweight popups cause SecurityExceptions in applets](https://bugs.openjdk.java.net/browse/JDK-6675802) -- *aterai* 2008-04-05 (土) 20:59:02
- メモ: [Bug ID: 6299213 The PopupMenu is not updated if the LAF is changed (incomplete fix of 4962731)](https://bugs.openjdk.java.net/browse/JDK-6299213) -- *aterai* 2008-04-10 (木) 18:58:52

<!-- dummy comment line for breaking list -->
