---
layout: post
title: TabComponentの名前を更新
category: swing
folder: RevalidateTabComponent
tags: [JTabbedPane, JPopupMenu, JButton]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-08-30

## TabComponentの名前を更新
`TabComponent`を使用する`JTabbedPane`で、タブ名称を編集更新します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh6.ggpht.com/_9Z4BYR88imo/TQTR4c_40eI/AAAAAAAAAh4/dLbGOWvSzSc/s800/RevalidateTabComponent.png)

### サンプルコード
<pre class="prettyprint"><code>class TabTitleRenamePopupMenu extends JPopupMenu {
  private final JTextField textField = new JTextField(10);
  private final Action renameAction = new AbstractAction("rename") {
    @Override public void actionPerformed(ActionEvent e) {
      JTabbedPane t = (JTabbedPane)getInvoker();
      int idx = t.getSelectedIndex();
      String title = t.getTitleAt(idx);
      textField.setText(title);
      int result = JOptionPane.showConfirmDialog(
        t, textField, "Rename", JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
      if(result==JOptionPane.OK_OPTION) {
        String str = textField.getText();
        if(!str.trim().isEmpty()) {
          t.setTitleAt(idx, str);
          JComponent c = (JComponent)t.getTabComponentAt(idx);
          c.revalidate();
        }
      }
    }
  };
  private final Action newTabAction = new AbstractAction("new tab") {
    @Override public void actionPerformed(ActionEvent evt) {
      JTabbedPane t = (JTabbedPane)getInvoker();
      int count = t.getTabCount();
      String title = "Tab " + count;
      t.add(title, new JLabel(title));
      t.setTabComponentAt(count, new ButtonTabComponent(t));
    }
  };
  private final Action closeAllAction = new AbstractAction("close all") {
    @Override public void actionPerformed(ActionEvent evt) {
      JTabbedPane t = (JTabbedPane)getInvoker();
      t.removeAll();
    }
  };
  public TabTitleRenamePopupMenu() {
    super();
    textField.addAncestorListener(new AncestorListener() {
      @Override public void ancestorAdded(AncestorEvent e) {
        textField.requestFocusInWindow();
      }
      @Override public void ancestorMoved(AncestorEvent e) {}
      @Override public void ancestorRemoved(AncestorEvent e) {}
    });
    add(renameAction);
    addSeparator();
    add(newTabAction);
    add(closeAllAction);
  }
  @Override public void show(Component c, int x, int y) {
    JTabbedPane t = (JTabbedPane)c;
    renameAction.setEnabled(t.indexAtLocation(x, y)&gt;=0);
    super.show(c, x, y);
  }
};
</code></pre>

### 解説
上記のサンプルでは、タブを閉じる`JButton`を`TabComponent`に追加した`JTabbedPane`に、タブ名称を変更する`JPopupMenu`を設定しています。

[How to Use Tabbed Panes (The Java™ Tutorials > Creating a GUI With JFC/Swing > Using Swing Components)](http://docs.oracle.com/javase/tutorial/uiswing/components/tabbedpane.html)の`ButtonTabComponent`を使っているので、`JTabbedPane#setTitleAt(...)`と名前を変更したときに、`tabbedPane.getTabComponentAt(idx)`で取得した`JComponent`を`revalidate()`することで、文字列の長さに応じたサイズへの変更と、タブの内部レイアウトの更新を行なっています。

### 参考リンク
- [How to Use Tabbed Panes (The Java™ Tutorials > Creating a GUI With JFC/Swing > Using Swing Components)](http://docs.oracle.com/javase/tutorial/uiswing/components/tabbedpane.html)
- [JTabbedPaneのタブにJTextFieldを配置してタイトルを編集](http://terai.xrea.jp/Swing/TabTitleEditor.html)
- [JTabbedPaneのタブタイトルを変更](http://terai.xrea.jp/Swing/EditTabTitle.html)
- [JTabbedPaneにタブを閉じるボタンを追加](http://terai.xrea.jp/Swing/TabWithCloseButton.html)

<!-- dummy comment line for breaking list -->

### コメント