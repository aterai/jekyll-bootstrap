---
layout: post
category: swing
folder: RevalidateTabComponent
title: TabComponentの名前を更新
tags: [JTabbedPane, JPopupMenu, JButton, JLabel]
author: aterai
pubdate: 2010-08-30T18:25:18+09:00
description: TabComponentを使用するJTabbedPaneで、タブ名称を編集更新します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTR4c_40eI/AAAAAAAAAh4/dLbGOWvSzSc/s800/RevalidateTabComponent.png
comments: true
---
## 概要
`TabComponent`を使用する`JTabbedPane`で、タブ名称を編集更新します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTR4c_40eI/AAAAAAAAAh4/dLbGOWvSzSc/s800/RevalidateTabComponent.png %}

## サンプルコード
<pre class="prettyprint"><code>class TabTitleRenamePopupMenu extends JPopupMenu {
  private final JTextField textField = new JTextField(10);
  private final Action renameAction = new AbstractAction("rename") {
    @Override public void actionPerformed(ActionEvent e) {
      JTabbedPane t = (JTabbedPane) getInvoker();
      int idx = t.getSelectedIndex();
      String title = t.getTitleAt(idx);
      textField.setText(title);
      int result = JOptionPane.showConfirmDialog(t, textField, "Rename",
          JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
      if (result == JOptionPane.OK_OPTION) {
        String str = textField.getText();
        if (!str.trim().isEmpty()) {
          t.setTitleAt(idx, str);
          JComponent c = (JComponent) t.getTabComponentAt(idx);
          c.revalidate();
        }
      }
    }
  };
  private final Action newTabAction = new AbstractAction("new tab") {
    @Override public void actionPerformed(ActionEvent evt) {
      JTabbedPane t = (JTabbedPane) getInvoker();
      int count = t.getTabCount();
      String title = "Tab " + count;
      t.add(title, new JLabel(title));
      t.setTabComponentAt(count, new ButtonTabComponent(t));
    }
  };
  private final Action closeAllAction = new AbstractAction("close all") {
    @Override public void actionPerformed(ActionEvent evt) {
      JTabbedPane t = (JTabbedPane) getInvoker();
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
    JTabbedPane t = (JTabbedPane) c;
    renameAction.setEnabled(t.indexAtLocation(x, y) &gt;= 0);
    super.show(c, x, y);
  }
};
</code></pre>

## 解説
上記のサンプルでは、タブを閉じる`JButton`を`TabComponent`に追加した`JTabbedPane`にタブ名称を変更する`JPopupMenu`を設定しています。

- [How to Use Tabbed Panes (The Java™ Tutorials > Creating a GUI With JFC/Swing > Using Swing Components)](https://docs.oracle.com/javase/tutorial/uiswing/components/tabbedpane.html)の`ButtonTabComponent`を使用
    - `JTabbedPane#setTitleAt(...)`メソッドで名前を変更したときに、`tabbedPane.getTabComponentAt(idx)`で取得した`JComponent`を`revalidate()`することで、文字列の長さに応じたサイズへの変更とタブの内部レイアウトの更新を実行

<!-- dummy comment line for breaking list -->

## 参考リンク
- [How to Use Tabbed Panes (The Java™ Tutorials > Creating a GUI With JFC/Swing > Using Swing Components)](https://docs.oracle.com/javase/tutorial/uiswing/components/tabbedpane.html)
- [JTabbedPaneのタブにJTextFieldを配置してタイトルを編集](https://ateraimemo.com/Swing/TabTitleEditor.html)
- [JTabbedPaneのタブタイトルを変更](https://ateraimemo.com/Swing/EditTabTitle.html)
- [JTabbedPaneにタブを閉じるボタンを追加](https://ateraimemo.com/Swing/TabWithCloseButton.html)

<!-- dummy comment line for breaking list -->

## コメント
