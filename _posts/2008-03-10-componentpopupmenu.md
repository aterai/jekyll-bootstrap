---
layout: post
title: JPopupMenuをコンポーネントに追加
category: swing
folder: ComponentPopupMenu
tags: [JPopupMenu, JTextComponent, PopupMenuListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-03-10

## JPopupMenuをコンポーネントに追加
`JPopupMenu`をコンポーネントに追加します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTKBw4_YtI/AAAAAAAAAVU/J_aFRLSj-VU/s800/ComponentPopupMenu.png)

### サンプルコード
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
        ((JTextComponent)getInvoker()).replaceSelection(null);
      }
    });
    addSeparator();
    add(selectAllAction = new AbstractAction("select all") {
      @Override public void actionPerformed(ActionEvent evt) {
        ((JTextComponent)getInvoker()).selectAll();
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
    JTextComponent textArea = (JTextComponent)c;
    boolean flg = textArea.getSelectedText()!=null;
    cutAction.setEnabled(flg);
    copyAction.setEnabled(flg);
    deleteAction.setEnabled(flg);
    super.show(c, x, y);
  }
}
</code></pre>

### 解説
上記のサンプルでは、`JTextArea`に`setComponentPopupMenu(JPopupMenu)`メソッドで、ポップアップメニューを追加しています。

`JDK 1.5`でこのメソッドが追加されたため、各コンポーネントにマウスリスナーを設定して、`e.isPopupTrigger()`でポップアップを表示するクリックかを判断するといったコードを書く必要が無くなりました。

ポップアップメニューを表示するときに、コンポーネントの状態(例えば`JTable`や`JList`などでの行選択の有無や、テキストが選択されてるかとどうかなどの条件)で、メニューが実行可か不可かを変更したい場合は、`JPopupMenu#show(Component, int, int)`メソッドをオーバーライドして使用します。

このサンプルでは、テキストが選択されている場合だけ、カット、コピー、削除メニューが有効になるよう設定しています。

- - - -
以下のように、`PopupMenuListener`を追加しても、同様の処理を行うことが出来ます。

- 注: `JTabbedPane`などで、どのタブの上でポップアップが表示されるかなどを取得したい場合[JTabbedPaneでタブを追加削除](http://terai.xrea.jp/Swing/TabbedPane.html)は、この方法だと面倒かも…

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JPopupMenu popup = new JPopupMenu();
final Action cutAction = new DefaultEditorKit.CutAction();
final Action copyAction = new DefaultEditorKit.CopyAction();
final Action pasteAction = new DefaultEditorKit.PasteAction();
final Action deleteAction = new AbstractAction("delete") {
  @Override public void actionPerformed(ActionEvent e) {
    JPopupMenu p = (JPopupMenu)e.getSource();
    ((JTextComponent)p.getInvoker()).replaceSelection(null);
  }
};
final Action selectAllAction = new AbstractAction("select all") {
  @Override public void actionPerformed(ActionEvent e) {
    JPopupMenu p = (JPopupMenu)e.getSource();
    ((JTextComponent)p.getInvoker()).selectAll();
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
  public void popupMenuCanceled(PopupMenuEvent e) {}
  public void popupMenuWillBecomeInvisible(PopupMenuEvent e) {}
  public void popupMenuWillBecomeVisible(PopupMenuEvent e) {
    JPopupMenu p = (JPopupMenu)e.getSource();
    JTextComponent c = (JTextComponent)p.getInvoker();
    boolean flg = c.getSelectedText()!=null;
    cutAction.setEnabled(flg);
    copyAction.setEnabled(flg);
    deleteAction.setEnabled(flg);
  }
});
textArea.setComponentPopupMenu(popup);
</code></pre>

### 参考リンク
- [JPopupMenuの取得を親に委譲](http://terai.xrea.jp/Swing/InheritsPopupMenu.html)
- [JTabbedPaneでタブを追加削除](http://terai.xrea.jp/Swing/TabbedPane.html)

<!-- dummy comment line for breaking list -->

### コメント
- メモ: [Bug ID: 6675802 Regression: heavyweight popups cause SecurityExceptions in applets](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6675802) -- [aterai](http://terai.xrea.jp/aterai.html) 2008-04-05 (土) 20:59:02
- メモ: [Bug ID: 6299213 The PopupMenu is not updated if the LAF is changed (incomplete fix of 4962731)](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6299213) -- [aterai](http://terai.xrea.jp/aterai.html) 2008-04-10 (木) 18:58:52

<!-- dummy comment line for breaking list -->

