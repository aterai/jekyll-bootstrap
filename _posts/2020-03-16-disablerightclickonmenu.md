---
layout: post
category: swing
folder: DisableRightClickOnMenu
title: JMenuとJMenuItemで右クリックによる選択を無効にする
tags: [JMenu, JMenuItem, WindowsLookAndFeel, LookAndFeel]
author: aterai
pubdate: 2020-03-16T00:36:39+09:00
description: JMenuとJMenuItemをマウスの右クリックで選択してもWindowsLookAndFeelの場合は無効になるよう設定します。
image: https://drive.google.com/uc?id=1RIzzl_rzPcMQIQGm9YL20ghL-xJKtT34
comments: true
---
## 概要
`JMenu`と`JMenuItem`をマウスの右クリックで選択しても`WindowsLookAndFeel`の場合は無効になるよう設定します。

{% download https://drive.google.com/uc?id=1RIzzl_rzPcMQIQGm9YL20ghL-xJKtT34 %}

## サンプルコード
<pre class="prettyprint"><code>class CustomWindowsMenuUI extends WindowsMenuUI {
  @Override protected MouseInputListener createMouseInputListener(JComponent c) {
    return new BasicMenuItemUI.MouseInputHandler() {
      @Override public void mousePressed(MouseEvent e) {
        if (SwingUtilities.isRightMouseButton(e)) {
          return;
        }
        super.mousePressed(e);
      }
    };
  }
}

class CustomWindowsMenuItemUI extends WindowsMenuItemUI {
  @Override protected MouseInputListener createMouseInputListener(JComponent c) {
    return new BasicMenuItemUI.MouseInputHandler() {
      @Override public void mouseReleased(MouseEvent e) {
        if (!menuItem.isEnabled() || SwingUtilities.isRightMouseButton(e)) {
          return;
        }
        super.mouseReleased(e);
      }
    };
  }
}
</code></pre>

## 解説
- `Default`
    - デフォルトの`WindowsLookAndFeel`では、`JMenu`や`JMenuItem`を右クリックで選択可能
- `DisableRightClick`
    - `WindowsLookAndFeel`が設定されている場合はマウスの右クリックを無効にする`CustomWindowsMenuUI`を設定
        
        <pre class="prettyprint"><code>JMenu menu1 = new JMenu("DisableRightClick") {
          @Override public void updateUI() {
            super.updateUI();
            if (getUI() instanceof WindowsMenuUI) {
              setUI(new CustomWindowsMenuUI());
            }
          }
        
          @Override public JMenuItem add(String s) {
            JMenuItem item = new JMenuItem(s) {
              @Override public void updateUI() {
                super.updateUI();
                if (getUI() instanceof WindowsMenuItemUI) {
                  setUI(new CustomWindowsMenuItemUI());
                }
              }
            };
            return add(item);
          }
        };
</code></pre>
    - `WindowsMenuUI#createMouseInputListener()`で生成される`MouseInputListener`を`BasicMenuItemUI.MouseInputHandler#mousePressed(...)`をオーバーライドしたリスナーに置き換え
    - `SwingUtilities.isRightMouseButton(e)`で右クリックの場合はなにも実行しない

<!-- dummy comment line for breaking list -->

- - - -
- デフォルトの`JMenu`に`setComponentPopupMenu(...)`で`JPopupMenu`を追加するとアプリケーションを終了するまで閉じることのできない`JPopupMenu`が開くバグ？がある
    - このサンプルのように右クリックを無効化してもこの動作を修正できない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JComboBoxのドロップダウンリストで右クリックを無効化](https://ateraimemo.com/Swing/DisableRightClick.html)
- [&#91;JDK-5032188&#93; Right Click on The JMenu Drops down the Menu unlike Native - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-5032188)

<!-- dummy comment line for breaking list -->

## コメント
