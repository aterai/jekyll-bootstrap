---
layout: post
category: swing
folder: FocusBeforePopup
title: JPopupMenuを開く前に対象となるJTextFieldにFocusを移動する
tags: [JPopupMenu, JTextField, Focus, JTextComponent]
author: aterai
pubdate: 2017-11-06T15:23:38+09:00
description: JTextFieldなどに設定したJPopupMenuをマウスの右クリックで開くとき、そのにFocusを移動し文字列を全選択します。
image: https://drive.google.com/uc?id=1DYqevQ-Nj2i5IptiAWC7KPYVKcbmuL9sMA
comments: true
---
## 概要
`JTextField`などに設定した`JPopupMenu`をマウスの右クリックで開くとき、その`JTextComponent`に`Focus`を移動し文字列を全選択します。

{% download https://drive.google.com/uc?id=1DYqevQ-Nj2i5IptiAWC7KPYVKcbmuL9sMA %}

## サンプルコード
<pre class="prettyprint"><code>class TextComponentPopupMenu extends JPopupMenu {
  private final Action cutAction = new DefaultEditorKit.CutAction();
  private final Action copyAction = new DefaultEditorKit.CopyAction();
  private final Action pasteAction = new DefaultEditorKit.PasteAction();
  protected TextComponentPopupMenu() {
    super();
    add(cutAction);
    add(copyAction);
    add(pasteAction);
  }
  @Override public void show(Component c, int x, int y) {
    System.out.println(c.getClass().getName() + ": " + c.getName());
    if (c instanceof JTextComponent) {
      JTextComponent tc = (JTextComponent) c;
      tc.requestFocusInWindow();
      boolean isSelected = tc.getSelectionStart() != tc.getSelectionEnd();
      if (tc instanceof JTextField &amp;&amp; !tc.isFocusOwner() &amp;&amp; !isSelected) {
        tc.selectAll();
        isSelected = true;
      }
      cutAction.setEnabled(isSelected);
      copyAction.setEnabled(isSelected);
      super.show(c, x, y);
    }
  }
}
</code></pre>

## 解説
- `Default setComponentPopupMenu`
    - `JTextField#setComponentPopupMenu(...)`で`JTextField`に`JPopupMenu`を設定
    - 別の`JTextComponent`にフォーカスがある状態で、この`JTextField`内を右クリックして`JPopupMenu`を表示してもフォーカスは前の`JTextComponent`に残る
    - `new DefaultEditorKit.PasteAction()`で生成した貼り込みアクションなどは、フォーカスのある`JTextComponent`に対して実行されるので、前の`JTextComponent`に文字列が張り込まれる
- `Override JPopupMenu#show(...)`
    - `JTextField#setComponentPopupMenu(...)`で`JTextField`に`JPopupMenu`を設定
    - `JPopupMenu#show(...)`をオーバーライドして`JPopupMenu`を開く前に`Component#requestFocusInWindow()`メソッドを実行し、この`JTextField`にフォーカスを移動する
        - `PopupMenuListener#popupMenuWillBecomeVisible(...)`、または`MouseListener#mousePressed(...)`をオーバーライドする方法でも構わない
    - フォーカス移動と合わせて、`JTextField`内を右クリックして`JPopupMenu`を開く場合は内部の文字列を全選択する処理を追加

<!-- dummy comment line for breaking list -->

- - - -
- `JPopupMenu does not open???`
    - 編集可能に設定した`JComboBox`の`JTextField`にマウスクリックでフォーカスを移動しても、他コンポーネントの`JPopupMenu`が開いたままになるバグ(仕様？)があるため、`JTextField#setComponentPopupMenu(...)`で追加した`JPopupMenu`を開くことができない
    - [JDK-8044493 Clicking on an editable JComboBox leaves JPopupMenus and other menus open - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8044493)
    - [Prevent popup menu dismissal | Exploding Pixels](https://explodingpixels.wordpress.com/2008/11/10/prevent-popup-menu-dismissal/)
        - `textField.putClientProperty("doNotCancelPopup", null);`で回避可能だが、エディタをマウスでクリックすると`JComboBox`のドロップダウンリストも閉じるようになる
            
            <pre class="prettyprint"><code>JComboBox&lt;String&gt; combo5 = new JComboBox&lt;&gt;(new String[] {"000", "111", "222"});
            combo5.setEditable(true);
            combo5.setComponentPopupMenu(popup2);
            JTextField textField5 = (JTextField) combo5.getEditor().getEditorComponent();
            textField5.putClientProperty("doNotCancelPopup", null);
</code></pre>
- `addMouseListener`
    - 編集可能に設定した`JComboBox`の`JTextField`に`MouseListener`を追加し、マウスでクリックされたら一旦すべての`JPopupMenu`を閉じるよう設定
        - ただし、自身の親の`JComboBox`が開いたドロップダウンリストは除外する
        - 参考: [MenuSelectionManagerですべてのJPopupMenuを取得する](https://ateraimemo.com/Swing/GetAllPopupMenus.html)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JComboBox&lt;String&gt; combo4 = new JComboBox&lt;&gt;(new String[] {"addMouseListener", "111", "222"});
combo4.setEditable(true);
JTextField textField4 = (JTextField) combo4.getEditor().getEditorComponent();
textField4.setComponentPopupMenu(popup2);
textField4.setName("textField4");
textField4.addMouseListener(new MouseAdapter() {
  @Override public void mousePressed(MouseEvent e) {
    System.out.println("Close all JPopUpMenu");
    // https://ateraimemo.com/Swing/GetAllPopupMenus.html
    for (MenuElement m : MenuSelectionManager.defaultManager().getSelectedPath()) {
      if (combo4.isPopupVisible()) {
        continue;
      } else if (m instanceof JPopupMenu) {
        ((JPopupMenu) m).setVisible(false);
      }
    }
  }
});
</code></pre>

## 参考リンク
- [DefaultEditorKitでポップアップメニューからコピー](https://ateraimemo.com/Swing/DefaultEditorKit.html)
- [MenuSelectionManagerですべてのJPopupMenuを取得する](https://ateraimemo.com/Swing/GetAllPopupMenus.html)
- [JTextField内のテキストをすべて選択](https://ateraimemo.com/Swing/SelectAll.html)
- [JDK-8044493 Clicking on an editable JComboBox leaves JPopupMenus and other menus open - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8044493)

<!-- dummy comment line for breaking list -->

## コメント
