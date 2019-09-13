---
layout: post
category: swing
folder: ComboBoxDropdownSelection
title: JComboBoxで編集した文字列をドロップダウンリストで選択する
tags: [JComboBox, JPopupMenu, PopupMenuListener]
author: aterai
pubdate: 2015-12-28T00:09:10+09:00
description: JComboBoxで編集した後の文字列がドロップダウンリスト中に存在する場合、そのアイテムを選択するように設定します。
image: https://lh3.googleusercontent.com/-EomuM0qaNtw/Vn_-BRt08_I/AAAAAAAAOJ0/hrUTPDKhroE/s800-Ic42/ComboBoxDropdownSelection.png
comments: true
---
## 概要
`JComboBox`で編集した後の文字列がドロップダウンリスト中に存在する場合、そのアイテムを選択するように設定します。

{% download https://lh3.googleusercontent.com/-EomuM0qaNtw/Vn_-BRt08_I/AAAAAAAAOJ0/hrUTPDKhroE/s800-Ic42/ComboBoxDropdownSelection.png %}

## サンプルコード
<pre class="prettyprint"><code>class SelectItemMenuListener implements PopupMenuListener {
  @Override public void popupMenuWillBecomeVisible(PopupMenuEvent e) {
    JComboBox c = (JComboBox) e.getSource();
    c.setSelectedItem(c.getEditor().getItem());
  }
  @Override public void popupMenuWillBecomeInvisible(PopupMenuEvent e) {}
  @Override public void popupMenuCanceled(PopupMenuEvent e) {}
}
</code></pre>

## 解説
- `Default`
    - `"123456"`を編集して`"a"`に変更し、ドロップダウンリストを開くと、`"123456"`が選択状態になる
- `popupMenuWillBecomeVisible`
    - `"123456"`を編集して`"a"`に変更し、ドロップダウンリストを開くと、`"a"`が選択状態になる
    - `PopupMenuListener`を追加し、`popupMenuWillBecomeVisible(...)`メソッドで編集された文字列がドロップダウンリストに存在する場合は選択する
    - ドロップダウンリストを開いたときに編集後の文字列がリストに存在しない場合は、選択状態はクリアされる
- `+enterPressed Action`
    - `"123456"`を編集して`"123456a"`に変更し<kbd>Enter</kbd>、次に文字列を`"a"`に変更してから、ドロップダウンリストを開くと、リストに`"123456a"`が追加され、`"a"`が選択状態になる
    - <kbd>Enter</kbd>キーを押した場合、アイテムを追加するアクションを`ActionMap`に追加
        
        <pre class="prettyprint"><code>Action defaultEnterPressedAction = getActionMap().get(ENTER_PRESSED);
        Action a = new AbstractAction() {
          @Override public void actionPerformed(ActionEvent e) {
            boolean isPopupVisible = isPopupVisible();
            setPopupVisible(false);
            DefaultComboBoxModel&lt;String&gt; m = (DefaultComboBoxModel&lt;String&gt;) getModel();
            String str = Objects.toString(getEditor().getItem(), "");
            if (m.getIndexOf(str) &lt; 0) {
              m.removeElement(str);
              m.insertElementAt(str, 0);
              if (m.getSize() &gt; 10) {
                m.removeElementAt(10);
              }
              setSelectedIndex(0);
              setPopupVisible(isPopupVisible);
            } else {
              defaultEnterPressedAction.actionPerformed(e);
            }
          }
        };
        getActionMap().put(ENTER_PRESSED, a);
</code></pre>
    - * 参考リンク [#reference]
- [PopupMenuListener#popupMenuWillBecomeVisible(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/event/PopupMenuListener.html#popupMenuWillBecomeVisible-javax.swing.event.PopupMenuEvent-)

<!-- dummy comment line for breaking list -->

## コメント
